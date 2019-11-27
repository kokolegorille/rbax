# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :rbax,
  ecto_repos: [Rbax.Repo]

# Configures the endpoint
config :rbax, RbaxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kxEa5cOMMn5n0+yZMSjC6yz6gOt1C37Intb7VbEPZdd3IEGn8hqwJZDZpN01a95w",
  render_errors: [view: RbaxWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Rbax.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# https://hexdocs.pm/phoenix/Phoenix.Logger.html
# filter sensitive information
config :phoenix, :filter_parameters, ["password", "password_hash"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
