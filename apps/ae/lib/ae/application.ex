defmodule Ae.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Ae.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Ae.PubSub}
      # Start a worker by calling: Ae.Worker.start_link(arg)
      # {Ae.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Ae.Supervisor)
  end
end
