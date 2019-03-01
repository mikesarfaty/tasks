use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tasks, TasksWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :tasks, Tasks.Repo,
  username: "tasks",
  password: "Eechai9taiju",
  database: "tasks_dev",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
