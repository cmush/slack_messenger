defmodule SlackMessenger.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias SlackMessenger.Utils.EnvVars

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      SlackMessenger.Repo,
      # Start the Telemetry supervisor
      SlackMessengerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: SlackMessenger.PubSub},
      # Start the Endpoint (http/https)
      SlackMessengerWeb.Endpoint,
      # Start a worker by calling: SlackMessenger.Worker.start_link(arg)
      # {SlackMessenger.Worker, arg}
      # Start a worker by calling: SlackMessenger.Worker.start_link(arg)
      SlackMessenger.HttpClient.child_spec(%{
        base_url: EnvVars.slack_base_url(),
        pool_size: EnvVars.slack_pool_size()
      })
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SlackMessenger.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SlackMessengerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
