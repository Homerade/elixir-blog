defmodule BlogWeb.SessionController do
  use BlogWeb, :controller

  alias Blog.Users

  plug(Web.Plugs.EnsureUser when action in [:logout_user])

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Users.validate_login(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:user_token, user.token)
        |> redirect(to: Routes.dashboard_path(conn, :index))

      {:error, _error} ->
        conn
        |> put_flash(:error, "Could not sign you in")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def logout_user(conn, _params) do
    %{current_user: user} = conn.assigns

    conn
    |> clear_session()
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
