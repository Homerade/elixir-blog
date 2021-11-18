defmodule Blog.Planets do
  import Ecto.Query

  alias Blog.Repo
  alias Blog.Planets.Planet

  def create(params) do
    %Planet{}
    |> Planet.create_changeset(params)
    |> Repo.insert()
  end

  def all(opts \\ []) do
    Planet
    |> filter(opts[:filter], __MODULE__)
    |> Repo.all()
  end

  def bulk_create(params) do
    Enum.each(params, fn planet ->
      %Planet{}
      |> Planet.create_changeset(planet)
      |> Repo.insert()
    end)
  end

  def filter(query, nil, _), do: query

  def filter(query, filter, module) do
    filter
    |> Enum.reject(&(elem(&1, 1) == ""))
    |> Enum.reduce(query, &module.filter_on_attribute/2)
  end
end
