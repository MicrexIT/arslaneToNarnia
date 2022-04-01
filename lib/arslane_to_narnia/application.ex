defmodule ArslaneToNarnia.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ArslaneToNarnia.Repo,
      # Start the Telemetry supervisor
      ArslaneToNarniaWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ArslaneToNarnia.PubSub},
      # Start the Endpoint (http/https)
      ArslaneToNarniaWeb.Endpoint,
      {Task.Supervisor, name: ArslaneToNarnia.BackgroundTask},
      {Oban, oban_config()}
      # Start a worker by calling: ArslaneToNarnia.Worker.start_link(arg)
      # {ArslaneToNarnia.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ArslaneToNarnia.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ArslaneToNarniaWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  # Conditionally disable queues or plugins here.
  defp oban_config do
    Application.fetch_env!(:arslane_to_narnia, Oban)
  end
end
