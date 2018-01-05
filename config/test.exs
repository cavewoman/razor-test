use Mix.Config

# We run a server during test for Wallaby integration testing.
config :razor_test, RazorTestWeb.Endpoint,
  http: [port: 4001],
  server: true,
  secret_key_base: "0123456789012345678901234567890123456789012345678901234567890123456789"

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :razor_test, RazorTest.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "razor_test_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :razor_test, :sql_sandbox, true
