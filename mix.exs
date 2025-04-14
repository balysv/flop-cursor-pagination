defmodule FlopTest.MixProject do
  use Mix.Project

  def project do
    [
      app: :flop_test,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {FlopTest.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.11"},
      {:ecto_psql_extras, "~> 0.7"},
      {:ecto_sql, "~> 3.10"},
      {:flop, "~> 0.26.1"},
      {:postgrex, "~> 0.17"}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
