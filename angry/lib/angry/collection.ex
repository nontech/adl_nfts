defmodule Angry.Collection do
  use Ecto.Schema

  schema "collections" do
    field :name, :string

    timestamps()
  end
end
