defmodule BlogWeb.RegistrationController do
  use BlogWeb, :controller

  alias Blog.Users
  alias Blog.Users.User

  def new(conn, _params) do
    conn
    |> assign(:changeset, Ecto.Changeset.change(%User{}, %{}))
    |> render("new.html")
  end

  def create(conn, %{"user" => params}) do
    IO.inspect params
    case Users.create(params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Account Created!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, changeset} ->

        conn
        |> put_status(422)
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end
end
