defmodule Blog.Accounts do
  import Ecto.Query
  require Ecto.Query

  alias Stein.Time

  @doc """
  Hash the changed password in a changeset
  - Skips if the changeset is invalid
  - Skips if a password is not changed
  - Hashes the password with BCrypt otherwise

  Requires the user schema to contain:
  - `password`, type `:string`
  - `password_hash`, type `:string`
  """
  def hash_password(changeset) do
    case changeset.valid? do
      true ->
        password = Ecto.Changeset.get_change(changeset, :password)

        case is_nil(password) do
          true ->
            changeset

          false ->
            hashed_password = Bcrypt.hash_pwd_salt(password)
            Ecto.Changeset.put_change(changeset, :password_hash, hashed_password)
        end

      false ->
        changeset
    end
  end

  def downcase_field(changeset, field) do
    case Ecto.Changeset.get_change(changeset, field) do
      nil ->
        changeset

      value ->
        Ecto.Changeset.put_change(changeset, field, String.downcase(value))
    end
  end

  def trim_field(changeset, field) do
    case Ecto.Changeset.get_change(changeset, field) do
      nil ->
        changeset

      value ->
        Ecto.Changeset.put_change(changeset, field, String.trim(value))
    end
  end

  # EMAIL VERIFICATION

  @doc """
  Prepare a user for email validation
  This should run as part of the create changeset when registering a new user
  """
  def start_email_verification_changeset(changeset) do
    changeset
    |> Ecto.Changeset.put_change(:email_verification_token, UUID.uuid4())
    |> Ecto.Changeset.put_change(:email_verified_at, nil)
  end

  # LOGGING IN

  # @doc """
  # Validate a email and password match a user

  # Requires the user schema to contain:
  # - `email`, type `:string`
  # - `password_hash`, type `:string`
  # """

  def validate_login(repo, schema, email, password) do
    case find_by_email(repo, schema, email) do
      {:error, :not_found} ->
        Bcrypt.no_user_verify()
        {:error, :not_found}

      {:ok, user} ->
        check_password(user, password)
    end
  end

  def check_password(user, password) do
    case Bcrypt.verify_pass(password, user.password_hash) do
      true ->
        {:ok, user}

      false ->
        {:error, :incorrect_password}
    end
  end

  @doc """
  Find a user by their email address
  Trims and downcases the email to find an existing user. Checks against
  the `lower` unique index on their email that should be set up when using
  Stein.
  """
  def find_by_email(repo, schema, email) do
    email =
      email
      |> String.trim()
      |> String.downcase()

    query =
      schema
      |> where([s], fragment("lower(?) = ?", s.email, ^email))
      |> limit(1)

    case repo.one(query) do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end

  @doc """
  Start the password reset process

  On successful start of reset, the success function will be called. This can be
  used to send the password reset email.

  Requires the user schema to contain:
  - `password_reset_token`, type `:uuid`
  - `password_reset_expires_at`, type `utc_datetime`
  """
  def start_password_reset(repo, schema, email, success_fun \\ fn _user -> :ok end) do
    case find_by_email(repo, schema, email) do
      {:ok, user} ->
        expires_at = DateTime.add(Time.now(), 3600, :second)

        user
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_change(:password_reset_token, UUID.uuid4())
        |> Ecto.Changeset.put_change(:password_reset_expires_at, expires_at)
        |> repo.update()
        |> maybe_run_success(success_fun)

        :ok

      {:error, :not_found} ->
        :ok
    end
  end

  defp maybe_run_success({:ok, user}, success_fun), do: success_fun.(user)

  defp maybe_run_success(_, _), do: :ok

  @doc """
  Finish resetting a password
  Takes the token, checks for expiration, and then resets the password
  """
  def reset_password(repo, struct, token, params) do
    with {:ok, uuid} <- Ecto.UUID.cast(token),
         {:ok, user} <- find_user_by_reset_token(repo, struct, uuid),
         {:ok, user} <- check_password_reset_expired(user) do
      user
      |> password_changeset(params)
      |> repo.update()
    end
  end

  defp find_user_by_reset_token(repo, struct, uuid) do
    case repo.get_by(struct, password_reset_token: uuid) do
      nil ->
        :error

      user ->
        {:ok, user}
    end
  end

  defp check_password_reset_expired(user) do
    case Time.after?(Time.now(), user.password_reset_expires_at) do
      true ->
        :error

      false ->
        {:ok, user}
    end
  end

  defp password_changeset(user, params) do
    user
    |> Ecto.Changeset.cast(params, [:password, :password_confirmation])
    |> Ecto.Changeset.validate_required([:password])
    |> Ecto.Changeset.validate_confirmation(:password)
    |> Ecto.Changeset.put_change(:password_reset_token, nil)
    |> Ecto.Changeset.put_change(:password_reset_expires_at, nil)
    |> hash_password()
    |> Ecto.Changeset.validate_required([:password_hash])
  end
end
