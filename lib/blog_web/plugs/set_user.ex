defmodule Web.Plugs.SetUser do
  @moduledoc """
  Set a user on the session
  """

  import Plug.Conn

  alias Blog.Users

  def init(default), do: default

  def call(conn, _opts) do
    case conn |> get_session(:user_token) do
      nil ->
        load_user(conn, nil)

      token ->
        load_user(conn, Users.get_by_token(token))
    end
  end

  defp load_user(conn, {:ok, user}) do
    conn
    |> assign(:current_user, user)
  end

  defp load_user(conn, nil) do
    conn
    |> assign(:current_user, nil)
  end
end
