defmodule Blog.Users do

  alias Blog.Users.User

  @doc """
  Creates a new user
  """
  def create(params) do
    User.create_changeset(%User{}, params)
  end
end
