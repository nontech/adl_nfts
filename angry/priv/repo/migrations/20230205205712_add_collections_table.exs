defmodule Angry.Repo.Migrations.AddCollectionsTable do
  use Ecto.Migration

  def change do
    create table(:collections) do
      add :name, :string, null: false
      timestamps()
    end
  end
end
