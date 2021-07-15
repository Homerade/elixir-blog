defmodule Blog.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blog.Accounts

  schema "users" do
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
    field(:password_hash, :string)
    field(:email_verification_token, Ecto.UUID)
    field(:email_verified_at, :utc_datetime)
    field(:password_reset_token, Ecto.UUID)
    field(:password_reset_expires_at, :utc_datetime)
    field(:token, Ecto.UUID, read_after_writes: true)

    timestamps()
  end

  def create_changeset(struct, attributes) do
    struct
    |> cast(attributes, [
      :email,
      :password,
      :password_hash,
      :email_verification_token,
      :email_verified_at,
      :password_reset_token,
      :password_reset_expires_at
    ])
    |> put_change(:token, UUID.uuid4())
    |> validate_required([:email])
    |> validate_required([:password])
    |> validate_confirmation(:password)
    |> validate_format(:email, ~r/.+@.+\..+/)
    |> unique_constraint(:email)
    |> Accounts.trim_field(:email)
    |> Accounts.downcase_field(:email)
    |> Accounts.hash_password()
    |> Accounts.start_email_verification_changeset()
    |> validate_required([:password_hash])
    |> unique_constraint(:email)
  end
end
