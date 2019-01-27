defmodule Mvp.Repo do
  use Ecto.Repo,
    otp_app: :mvp,
    adapter: Ecto.Adapters.Postgres
end
