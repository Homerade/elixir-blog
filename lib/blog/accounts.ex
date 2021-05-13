defmodule Blog.Accounts do
  require Ecto.Query

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

  # LOGGIN IN

  @doc """
  Validate a email and password match a user

  Requires the user schema to contain:
  - `email`, type `:string`
  - `password_hash`, type `:string`
  """

  # def validate_login(repo, schema, email, password) do
  #   case find_by_email(repo, schema, email) do
  #     {:error, :not_found} ->
  #       Bcrypt.no_user_verify()
  #       {:error, :invalid}

  #     {:ok, user} ->
  #       check_password(user, password)
  #   end
  # end

  # defp check_password(user, password) do
  #   case Bcrypt.verify_pass(password, user.password_hash) do
  #     true ->
  #       {:ok, user}

  #     false ->
  #       {:error, :invalid}
  #   end
  # end

  @doc """
  Find a user by their email address
  Trims and downcases the email to find an existing user. Checks against
  the `lower` unique index on their email that should be set up when using
  Stein.
  """
  # def find_by_email(repo, schema, email) do
  #   email =
  #     email
  #     |> String.trim()
  #     |> String.downcase()

  #   query =
  #     schema
  #     |> Query.where([s], fragment("lower(?) = ?", s.email, ^email))
  #     |> Query.limit(1)

  #   case repo.one(query) do
  #     nil ->
  #       {:error, :not_found}

  #     user ->
  #       {:ok, user}
  #   end
  # end
end
