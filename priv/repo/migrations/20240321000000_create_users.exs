defmodule FlopTest.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: true

      timestamps()
    end
  end
end
