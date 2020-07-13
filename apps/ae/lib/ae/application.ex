defmodule Ae.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    base = [
      Ae.Repo,
      {Phoenix.PubSub, name: Ae.PubSub}
    ]

    oban = if System.get_env("WITH_OBAN"), do: [{Oban, Application.get_env(:ae, Oban)}], else: []

    children = base ++ oban

    Supervisor.start_link(children, strategy: :one_for_one, name: Ae.Supervisor)
  end
end
