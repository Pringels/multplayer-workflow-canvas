defmodule Liveflow.Repo do
  use Ecto.Repo,
    otp_app: :liveflow,
    adapter: Ecto.Adapters.Postgres
end
