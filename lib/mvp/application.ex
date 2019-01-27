defmodule Mvp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Mvp.Repo,
      # Start the endpoint when the application starts
      MvpWeb.Endpoint
      # Starts a worker by calling: Mvp.Worker.start_link(arg)
      # {Mvp.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mvp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MvpWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
