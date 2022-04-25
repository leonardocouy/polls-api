defmodule Polls.Repo do
  use Ecto.Repo,
    otp_app: :polls,
    adapter: Ecto.Adapters.Postgres
end
