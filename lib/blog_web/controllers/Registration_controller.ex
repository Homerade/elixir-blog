defmodule BlogWeb.RegistrationController do
  use BlogWeb, :controller

  alias Blog.Users
  alias Blog.Users.User
  alias Blog.Mailer
  alias Blog.Email

  def new(conn, _params) do
    conn
    |> assign(:changeset, Ecto.Changeset.change(%User{}, %{}))
    |> render("new.html")
  end

  def create(conn, %{"user" => params}) do
    case Users.create(params) do
      {:ok, _user} ->
        send_verification_email(params["email"])
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

  defp send_verification_email(user) do
    Email.verification_email(user)
    |> Mailer.deliver_now()
  end

  defp send_reset_password_email do
    Email.reset_password_email
    |> Mailer.deliver_now
  end
end
