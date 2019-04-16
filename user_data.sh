#!/bin/bash

# Create the deploy user
sudo useradd -m -d /home/deploy -s /bin/bash deploy
# and add let it passwordless sudo
sudo sh -c "echo 'deploy ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/99-deploy-user"

echo 'export PATH=$PATH:~/.local/bin' >> bash_profile
echo 'ulimit -c unlimited' >> bash_profile
cp bash_profile /home/deploy/.bash_profile
chown deploy:deploy /home/deploy/.bash_profile

## Install SSH keys
aws s3 cp s3://appcues-servers/shared/users.sh - | bash

## Create SSL certs
aws s3 cp s3://appcues-servers/shared/ssl.sh - | bash

## Install packages
aws s3 cp s3://appcues-servers/shared/packages.sh - | bash
aws s3 cp s3://appcues-servers/api/packages.sh - | bash

## Update crontab
aws s3 cp s3://appcues-servers/api/cron.sh - | bash

# Set up main code directory
sudo mkdir -p /var/www/api/api
sudo chown -R deploy:deploy /var/www/api/api

# Update the open file and memory things
# Lovingly cargo-culted from:
# https://gist.github.com/Gazler/c539b7ef443a6ea5a182
# and
# http://phoenixframework.org/blog/the-road-to-2-million-websocket-connections
sudo sh -c "echo '
* soft     nproc          4000000
* hard     nproc          4000000
* soft     nofile         4000000
* hard     nofile         4000000
root soft     nproc          4000000
root hard     nproc          4000000
root soft     nofile         4000000
root hard     nofile         4000000' >> /etc/security/limits.conf"
sudo sysctl -w fs.file-max=12000500
sudo sysctl -w fs.nr_open=20000500
sudo sysctl -w net.ipv4.tcp_mem='10000000 10000000 10000000'
sudo sysctl -w net.ipv4.tcp_rmem='1024 4096 16384'
sudo sysctl -w net.ipv4.tcp_wmem='1024 4096 16384'
sudo sysctl -w net.core.rmem_max=16384
sudo sysctl -w net.core.wmem_max=16384
sudo sysctl -w net.ipv4.ip_local_port_range="1024 64000"
sudo sh -c "echo 'session required pam_limits.so' >> /etc/pam.d/common-session"

# Run user-setup.sh.
aws s3 cp s3://server-stuff/mvp/user-setup.sh /home/deploy/user-setup.sh
cd /home/deploy
sudo -u deploy -i bash user-setup.sh

