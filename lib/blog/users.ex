defmodule Blog.Users do
  alias Blog.Users.User
  alias Blog.Repo

  alias Blog.Accounts
  alias Blog.Email
  alias Blog.Mailer

  @fourty_eight_hours_in_seconds 48 * 60 * 60
  @doc """
  Changeset for a session or registration
  """
  def new(), do: Ecto.Changeset.change(%User{}, %{})

  @doc """
  Creates a new user
  """
  def create(params) do
    %User{}
    |> User.create_changeset(params)
    |> Repo.insert()
  end

  @doc """
  Send user welcome email to pending users
  Sets their password_reset_expires_at to 48 hours
  """
  def send_welcome_email(user) do
    Accounts.start_password_reset(Repo, User, user.email, fn user ->
      user
      |> update_password_expiration(@fourty_eight_hours_in_seconds)
      |> Email.welcome_email()
      |> Mailer.deliver_now()
    end)
  end

  @doc """
  Start to reset a user's password
  """
  def start_password_reset(email) do
    Accounts.start_password_reset(Repo, User, email, fn user ->
      user
      |> Email.reset_password_email()
      |> Mailer.deliver_now()
    end)
  end

  # Shifts password reset expiration by the given number of seconds.
  defp update_password_expiration(user, seconds_to_shift) do
    expires_at =
      DateTime.utc_now()
      |> DateTime.truncate(:second)
      |> DateTime.add(seconds_to_shift, :second)

    user
    |> Ecto.Changeset.change(%{password_reset_expires_at: expires_at})
    |> Repo.update!()
  end

  @doc """
  Reset the users's password based on a valid reset token

  Also unlocks the user's account if it was previously locked
  """
  def reset_password(token, params) do
    result =
      Ecto.Multi.new()
      |> Ecto.Multi.run(:reset, fn _repo, _changes ->
        # Hey, future person.
        # Make Stein not ever return bare :error atom
        case Stein.Accounts.reset_password(Repo, User, token, params) do
          {:ok, value} ->
            {:ok, value}

          {:error, changeset} ->
            {:error, changeset}

          :error ->
            {:error, :stein_failure}
        end
      end)
      |> Ecto.Multi.update(:unlock, fn %{reset: user} ->
        Ecto.Changeset.change(user, %{locked_until: nil})
      end)
      |> Repo.transaction()

    case result do
      {:ok, %{unlock: user}} ->
        {:ok, user}

      {:error, _tag, changeset, _changes} ->
        {:error, changeset}
    end
  end
end
