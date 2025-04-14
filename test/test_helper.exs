ExUnit.start()

# Start the application and sandbox
{:ok, _} = Application.ensure_all_started(:flop_test)
{:ok, _} = Application.ensure_all_started(:ecto_sql)
:ok = Ecto.Adapters.SQL.Sandbox.mode(FlopTest.Repo, :manual)
