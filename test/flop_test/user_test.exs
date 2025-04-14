defmodule FlopTest.UserTest do
  use FlopTest.DataCase
  import ExUnit.Case

  alias FlopTest.User

  setup do
    [nil, nil, "a", "b", "c", "d", nil, nil]
    |> Enum.each(fn name ->
      Repo.insert(%User{name: name})
    end)
  end

  test "page ends in `nil`" do
    query = from(u in User)

    {:ok, {results, meta}} =
      Flop.validate_and_run(
        query,
        %{first: 5, order_by: [:name, :id], order_directions: [:asc]},
        for: User
      )

    # Results: [{"a", 3}, {"b", 4}, {"c", 5}, {"d", 6}, {nil, 7}]
    assert Enum.map(results, & &1.name) == ["a", "b", "c", "d", nil]

    {:ok, {results, meta}} =
      Flop.validate_and_run(
        query,
        %{first: 5, after: meta.end_cursor, order_by: [:name, :id], order_directions: [:asc]},
        for: User
      )

    # Results: [{"a", 3}, {"b", 4}, {"c", 5}, {"d", 6}, {nil, 7}]
    # but instead it should be: [{nil, 7}, {nil, 8}]
    assert Enum.map(results, & &1.name) == [nil, nil]
  end

  test "extra fields hack for a page ending in `nil`" do
    extra_fields_query =
      from(u1 in User,
        where: u1.id == parent_as(:user).id,
        select: %{
          name_c: fragment("COALESCE(?, 'zzzzzzzzzzzzzz')", u1.name)
        }
      )

    query =
      from(u in User, as: :user)
      |> join(:inner_lateral, [user: u], f in subquery(extra_fields_query),
        on: true,
        as: :extra_fields
      )

    {:ok, {results, meta}} =
      Flop.validate_and_run(
        query,
        %{first: 5, order_by: [:name_c, :id], order_directions: [:asc]},
        for: User
      )

    # Results: [{"a", 3}, {"b", 4}, {"c", 5}, {"d", 6}, {nil, 7}]
    assert Enum.map(results, & &1.name) == ["a", "b", "c", "d", nil]

    {:ok, {results, meta}} =
      Flop.validate_and_run(
        query,
        %{first: 5, after: meta.end_cursor, order_by: [:name_c, :id], order_directions: [:asc]},
        for: User
      )

    # Results: [{"a", 3}, {"b", 4}, {"c", 5}, {"d", 6}, {nil, 7}]
    # but instead it should be: [{nil, 7}, {nil, 8}]
    assert Enum.map(results, & &1.name) == [nil, nil]
  end

  test "page ends in value, `nil`s to follow" do
    query = from(u in User)

    {:ok, {results, meta}} =
      Flop.validate_and_run(
        query,
        %{first: 3, order_by: [:name, :id], order_directions: [:asc]},
        for: User
      )

    # Results: page1: [{"a", 3}, {"b", 4}, {"c", 5}]
    assert Enum.map(results, & &1.name) == ["a", "b", "c"]

    {:ok, {results, meta}} =
      Flop.validate_and_run(
        query,
        %{first: 100, after: meta.end_cursor, order_by: [:name, :id], order_directions: [:asc]},
        for: User
      )

    # Results: page2: [{"d", 6}] - all `nils` are filtered out
    assert Enum.map(results, & &1.name) == ["d", nil, nil]
  end
end
