defmodule Angry.Nft do
  use Ecto.Schema

  schema "nfts" do
    field :name, :string
    field :description, :string
    field :price, :integer
    field :available, :boolean

    # one-to-one
    belongs_to(:owner, Angry.User)
    belongs_to(:collection, Angry.Collection)

    timestamps()
  end
end
