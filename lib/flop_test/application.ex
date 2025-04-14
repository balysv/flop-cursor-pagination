defmodule FlopTest.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FlopTest.Repo
    ]

    opts = [strategy: :one_for_one, name: FlopTest.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
