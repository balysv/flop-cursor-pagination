import Config

# Configure your database
config :flop_test, FlopTest.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "flop_test",
  port: 5555,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# Configure Ecto Repo
config :flop_test,
  ecto_repos: [FlopTest.Repo]

config :flop, repo: FlopTest.Repo
