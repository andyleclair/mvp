#!/bin/bash

# Commands here will be run as `deploy`.
APP="mvp"
APP_ENV="prod"
LATEST_RELEASE=$(aws s3 ls s3://server-stuff/$APP/$APP_ENV/ | grep $APP | sort | tail -1 | awk '{print $4}')
aws s3 cp s3://server-stuff/$APP/$APP_ENV/$LATEST_RELEASE .
tar -xzf $LATEST_RELEASE -C /var/www/$APP/$APP
ssh-keygen -q -f ~/.ssh/id_rsa -N ''
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
ssh localhost -o StrictHostKeyChecking=no /var/www/$APP/$APP/bin/$APP start
