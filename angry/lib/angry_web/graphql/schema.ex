defmodule AngryWeb.Graphql.Schema do
  use Absinthe.Schema
  alias Angry.Nft
  alias Angry.Repo
  import Ecto.Query

  # QUERIES
  # ---------------------------------------
  query do
    field :nft, non_null(:nft) do
      arg(:id, non_null(:id))
      resolve(&get_nft/3)
    end

    field :nfts, list_of(:nft) do
      resolve(&list_nfts/3)
    end

    # Search NFTs by collection, owner, properties or sales
    field :search, list_of(:nft) do
      arg(:search_by, non_null(:properties))
      resolve(&filter_nfts/3)
    end
  end

  # OBJECTS
  # ---------------------------------------
  @desc "A NFT"
  object :nft do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :description, non_null(:string)
    field :owner, non_null(:user)
    field :collection, non_null(:collection)
    field :price, non_null(:integer)
    field :available, non_null(:boolean)
  end

  @desc "A User"
  object :user do
    field :username, non_null(:string)
  end

  @desc "A Collection"
  object :collection do
    field :name, non_null(:string)
  end

  # RESOLVERS
  # ---------------------------------------
  defp get_nft(_parent, %{id: id}, _resolution) do
    nft =
      Repo.get!(Nft, id)
      |> Repo.preload([:owner, :collection])

    {:ok, nft}
  end

  defp list_nfts(_parent, _args, _resolution) do
    nfts_list = [
      %{
        id: 1,
        name: 'T-Rex',
        description: '',
        owner: '1337_CV',
        collection: 'water',
        price: 100,
        available: true
      },
      %{
        id: 2,
        name: 'Triceratops',
        description: '',
        owner: 'Paradoxor',
        collection: 'fire',
        price: 200,
        available: false
      },
      %{
        id: 3,
        name: 'Brontosaurus',
        description: '',
        owner: 'Radidar',
        collection: 'earth',
        price: 800,
        available: true
      }
    ]

    {:ok, nfts_list}
    # nfts_list
  end

  defp filter_nfts(
         _parent,
         %{search_by: %{name: name, owner: owner, available: available, collection: collection}} =
           _args,
         _resolution
       ) do
    query =
      from n in Nft,
        left_join: o in assoc(n, :owner),
        left_join: c in assoc(n, :collection),
        where:
          n.name == ^name and o.username == ^owner and c.name == ^collection and
            n.available == ^available,
        preload: [owner: o, collection: c]

    resp = Repo.all(query)

    {:ok, resp}

    # filtered_nfts = [
    #   %{
    #     id: 1,
    #     name: 'Velociraptor',
    #     description: '',
    #     owner: 'MRD',
    #     collection: 'water',
    #     price: 100,
    #     available: true
    #   },
    #   %{
    #     id: 2,
    #     name: 'Diplodocus',
    #     description: '',
    #     owner: 'Terry',
    #     collection: 'fire',
    #     price: 200,
    #     available: false
    #   }
    # ]

    # {:ok, filtered_nfts}
  end

  # INPUT OBJECTS
  # ---------------------------------------
  # merely here to model structure
  # does not have any args or a resolver of its own

  @desc "User searches for NFTs by"
  input_object :properties do
    field :name, non_null(:string)
    field :owner, non_null(:string)
    field :collection, non_null(:string)
    field :available, non_null(:boolean)
  end
end
