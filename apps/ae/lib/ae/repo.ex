defmodule Ae.Repo do
  use Ecto.Repo,
    otp_app: :ae,
    adapter: Ecto.Adapters.Postgres
end
