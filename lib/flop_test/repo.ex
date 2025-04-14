defmodule FlopTest.Repo do
  use Ecto.Repo,
    otp_app: :flop_test,
    adapter: Ecto.Adapters.Postgres
end
