defmodule Blog.Users do

  alias Blog.Users.User
  alias Blog.Repo

  @doc """
  Creates a new user
  """
  def create(params) do
    %User{}
    |> User.create_changeset(params)
    |> Repo.insert()
  end
end
