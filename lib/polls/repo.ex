defmodule Polls.Repo do
  use Ecto.Repo,
    otp_app: :polls,
    adapter: Ecto.Adapters.Postgres

  def init(_, config) do
    config =
      config
      |> Keyword.put(:username, System.get_env("PGUSER") || "postgres")
      |> Keyword.put(:password, System.get_env("PGPASSWORD") || "postgres")
      |> Keyword.put(:hostname, System.get_env("PGHOST") || "localhost")
      |> Keyword.put(:port, (System.get_env("PGPORT") || "5432") |> String.to_integer())

    {:ok, config}
  end
end
