defmodule Liveflow.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LiveflowWeb.Telemetry,
      Liveflow.Repo,
      {DNSCluster, query: Application.get_env(:liveflow, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Liveflow.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Liveflow.Finch},
      # Start a worker by calling: Liveflow.Worker.start_link(arg)
      # {Liveflow.Worker, arg},
      # Start to serve requests, typically the last entry
      LiveflowWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Liveflow.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveflowWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
