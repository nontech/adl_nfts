defmodule Angry.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: Angry.Repo

  alias Faker.{Lorem, Date}
  alias Angry.User
  alias Angry.Nft
  alias Angry.Collection

  def user_factory do
    %User{
      id: System.unique_integer([:positive]),
      username: Lorem.word()
    }
  end

  def nft_factory do
    %Nft{
      id: System.unique_integer([:positive]),
      name: Lorem.word(),
      description: Lorem.word(),
      owner_id: System.unique_integer([:positive]),
      collection_id: System.unique_integer([:positive]),
      # owner: build(:user),
      # collection: build(:collection),
      price: System.unique_integer([:positive]),
      available: true
    }
  end

  def collection_factory do
    %Collection{
      id: System.unique_integer([:positive]),
      name: sequence(:name, ["earth", "water", "fire", "air"])
    }
  end
end
