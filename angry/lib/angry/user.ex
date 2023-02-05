defmodule Angry.User do
  use Ecto.Schema

  schema "users" do
    field :username, :string

    timestamps()
  end
end
