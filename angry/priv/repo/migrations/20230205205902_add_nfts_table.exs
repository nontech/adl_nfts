defmodule Angry.Repo.Migrations.AddNftsTable do
  use Ecto.Migration

  def change do
    create table(:nfts) do
      add(:name, :string)
      add(:description, :string, default: "")
      add(:price, :integer)
      add(:available, :boolean)
      add(:owner_id, references("users"))
      add(:collection_id, references("collections"))

      timestamps()
    end
  end
end
