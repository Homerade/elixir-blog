defmodule Blog.Email do
  import Bamboo.Email

  alias BlogWeb.Endpoint
  alias BlogWeb.Router.Helpers, as: Routes

  def reset_password_email(user) do
    reset_url = Routes.password_reset_path(Endpoint, :edit, user.password_reset_token)

    new_email(
      from: "stephanie+bamboo_test@smartlogic.io",
      to: user.email,
      subject: "Password Reset",
      text_body: "Reset password for #{user.email} using this link: ",
      html_body: "<h2>Reset your password using this link</h2>
        <a href=\"#{reset_url}\">here is the reset link</a>
        <p>now good for 1 hour</p>"
    )
  end

  def verification_email(new_user) do
    new_email(
      to: new_user,
      from: "stephanie+bamboo_test@smartlogic.io",
      subject: "Verify your email",
      html_body: "<strong>Verify!</strong>",
      text_body: "As a new user you can now post new blogs to the site!"
    )
  end

  def welcome_email(new_user) do
    new_email(
      to: new_user,
      from: "stephanie+bamboo_test@smartlogic.io",
      subject: "Welcome email",
      html_body: "<strong>Welcome!</strong>",
      text_body: "As a new user you can now post new blogs to the site!"
    )
  end
end
