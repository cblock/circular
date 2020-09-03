defmodule Circular.Repo do
  use Ecto.Repo,
    otp_app: :circular,
    adapter: Ecto.Adapters.Postgres
end
