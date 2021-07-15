defmodule Blog.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change() do
    create table(:users) do
      add(:email, :string)
      add(:password_hash, :string)

      add(:email_verification_token, :uuid)
      add(:email_verified_at, :utc_datetime)

      add(:password_reset_token, :uuid)
      add(:password_reset_expires_at, :utc_datetime)

      timestamps()
    end

    create index(:users, ["lower(email)"], unique: true)
  end
end
