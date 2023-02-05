defmodule Angry.Repo do
  use Ecto.Repo,
    otp_app: :angry,
    adapter: Ecto.Adapters.Postgres
end
