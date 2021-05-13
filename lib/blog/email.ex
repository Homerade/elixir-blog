defmodule Blog.Email do
  import Bamboo.Email
  import Bamboo.Phoenix

  def reset_password_email do
    new_email(
      from: "stephanie+bamboo_test@smartlogic.io",
      to: "stephanie@smartlogic.io",
      subject: "this is a bamboo test",
      text_body: "See this text body",
      html_body: "<h1>Do We</h1><p>really need this?</p>"
    )
  end

  def verification_email(new_user) do
    new_email(
      to: new_user,
      from: "stephanie+bamboo_test@smartlogic.io",
      subject: "Verify your email",
      html_body: "<strong>Welcome!</strong>",
      text_body: "As a new user you can now post new blogs to the site!"
    )
  end
end
