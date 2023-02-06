defmodule AngryWeb.Graphql.SchemaTest do
  use AngryWeb.ConnCase
  import Angry.Factory

  describe "nfts graphql" do
    @nft_query """
    query getNft($id: ID!) {
      nft(id: $id) {
        name
        description
        owner {
          username
        }
        collection {
          name
        }
      }
    }
    """

    test "query: nft", %{conn: conn} do
      # creating nft requires user and collection
      # insert a user
      owner = insert(:user)
      # insert collection
      collection = insert(:collection)

      # insert a nft in test db
      nft = insert(:nft, %{owner_id: owner.id, collection_id: collection.id})

      # make a query
      conn =
        post(conn, "/api/graphql", %{
          "query" => @nft_query,
          "variables" => %{id: nft.id}
        })

      resp =
        conn
        |> json_response(200)

      assert resp == %{
               "data" => %{
                 "nft" => %{
                   "collection" => %{"name" => collection.name},
                   "description" => nft.description,
                   "name" => nft.name,
                   "owner" => %{"username" => owner.username}
                 }
               }
             }
    end

    @search """
    query search($searchArgs: Properties!) {
      search(searchBy: $searchArgs) {
        name
        description
        owner {
          username
        }
        collection {
          name
        }
      }
    }
    """
    test "search: nfts", %{conn: conn} do
      # creating nft requires user and collection
      # insert a user
      owner = insert(:user, %{username: "John Doe"})
      # insert collection
      collection = insert(:collection, %{name: "water"})

      # insert NFTs in test db
      nft_1 =
        insert(:nft, %{name: "Bored Dynosaur", owner_id: owner.id, collection_id: collection.id})

      nft_2 =
        insert(:nft, %{
          name: "Flying Dynosaur",
          owner_id: owner.id,
          collection_id: collection.id,
          available: false
        })

      # search terms
      # limitation: all fields must be defined
      variables = %{
        searchArgs: %{
          name: "Bored Dynosaur",
          owner: "John Doe",
          collection: "water",
          available: true
        }
      }

      # make a query
      conn =
        post(conn, "/api/graphql", %{
          "query" => @search,
          "variables" => variables
        })

      resp =
        conn
        |> json_response(200)

      assert resp == %{
               "data" => %{
                 "search" => [
                   %{
                     "collection" => %{"name" => collection.name},
                     "description" => nft_1.description,
                     "name" => nft_1.name,
                     "owner" => %{"username" => owner.username}
                   }
                 ]
               }
             }
    end
  end
end
