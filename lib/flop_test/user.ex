defmodule FlopTest.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [],
    sortable: [:id, :name, :name_c],
    default_order: %{
      order_by: [:id],
      order_directions: [:asc]
    },
    default_pagination_type: :offset,
    pagination_types: [:first, :last, :offset],
    # "extra_fields" hack to try force a coalesce
    adapter_opts: [
      join_fields: [
        name_c: [
          binding: :extra_fields,
          field: :name_c,
          ecto_type: :string
        ]
      ]
    ]
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
