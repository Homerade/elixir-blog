defmodule Blog.Repo.Migrations.AddTokenToUsers do
  use Ecto.Migration

  def up do
    execute "ALTER TABLE users ADD COLUMN token uuid"
  end

  def down do
    execute "ALTER TABLE users DROP COLUMN token"
  end
end
