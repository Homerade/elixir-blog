defmodule BlogWeb.LayoutView do
  use BlogWeb, :view

  def user_access_link(conn = %{assigns: %{current_user: nil}}) do
    content_tag(:div, class: "login-container") do
      [
        link("sign up / ", to: Routes.registration_path(conn, :new)),
        link("login", to: Routes.session_path(conn, :new))
      ]
    end
  end

  def user_access_link(conn = %{assigns: %{current_user: _current_user}}) do
    content_tag(:div, class: "login-container") do
      [
        link("logout", to: Routes.session_path(conn, :logout_user))
      ]
    end
  end
end
