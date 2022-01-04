import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :slack_messenger, SlackMessenger.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "slack_messenger_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# Configure the database for GitHub Actions
if System.get_env("GITHUB_ACTIONS") do
  config :slack_messenger, SlackMessenger.Repo,
    username: "postgres",
    password: "postgres"
end

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :slack_messenger, SlackMessengerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "dGIXPthlesdVHrrQCTpeqvbEKPPrMqejtVJW/LA26QK/shMkog3srwgpZMl8q4eE",
  server: false

# In test we don't send emails.
config :slack_messenger, SlackMessenger.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
