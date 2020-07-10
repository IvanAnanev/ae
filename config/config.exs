# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :ae,
  ecto_repos: [Ae.Repo]

config :ae_web,
  ecto_repos: [Ae.Repo],
  generators: [context_app: :ae]

# Configures the endpoint
config :ae_web, AeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "XY3vxe3tgXlaRmlpEDxQH3iZL+xG/3NB6SX0JuLuApsA7rDgNzL6YEutgaELp/fD",
  render_errors: [view: AeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Ae.PubSub,
  live_view: [signing_salt: "GAzhX6Qg"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
