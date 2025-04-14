defmodule FlopTest.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [],
    sortable: [:id, :name],
    default_order: %{
      order_by: [:id],
      order_directions: [:asc]
    },
    default_pagination_type: :offset,
    pagination_types: [:first, :last, :offset]
  }

  schema "users" do
    field(:name, :string)

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([])
  end
end
