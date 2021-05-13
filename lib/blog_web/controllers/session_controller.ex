defmodule Web.SessionController do
  use BlogWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    # case Users.validate_login(email, password) do
    #   {:ok, user} ->
    #     conn
    #     |> put_session(:user_token, user.token)
    #     |> redirect(to: Routes.dashboard_path(conn, :index))

    #   {:error, _error} ->
    #     conn
    #     |> put_flash(:error, "Could not sign you in")
    #     |> redirect(to: Routes.session_path(conn, :new))
    # end
  end
end
