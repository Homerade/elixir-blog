defmodule Blog.Accounts do

  require Ecto.Query


  def start_email_verification_changeset(changeset) do
    changeset
    |> Ecto.Changeset.put_change(:email_verification_token, UUID.uuid4())
    |> Ecto.Changeset.put_change(:email_verified_at, nil)
  end

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
end
