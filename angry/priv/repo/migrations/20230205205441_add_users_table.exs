defmodule Angry.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false

      timestamps()
    end
  end
end
