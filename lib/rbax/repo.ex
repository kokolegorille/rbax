defmodule Rbax.Repo do
  use Ecto.Repo,
    otp_app: :rbax,
    adapter: Ecto.Adapters.Postgres
end
