# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :razor_test,
  ecto_repos: [RazorTest.Repo]

# Configures the endpoint
config :razor_test, RazorTestWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: RazorTestWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: RazorTest.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: RazorTest.Coherence.User,
  repo: RazorTest.Repo,
  module: RazorTest,
  web_module: RazorTestWeb,
  router: RazorTestWeb.Router,
  messages_backend: RazorTestWeb.Coherence.Messages,
  logged_out_url: "/",
  email_from_name: "Deck Box",
  email_from_email: "anna.sherman365@gmail.com",
  opts: [:authenticatable, :recoverable, :lockable, :trackable, :unlockable_with_token, :registerable]

config :coherence, RazorTestWeb.Coherence.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: {:system, "SENDGRID_API_KEY"}
# %% End Coherence Configuration %%
