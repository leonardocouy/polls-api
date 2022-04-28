defmodule Polls.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :option_id, references(:options, on_delete: :delete_all)
      add :owner_id, references(:users, on_delete: :nilify_all)

      timestamps()
    end

    create index(:votes, [:option_id])
    create index(:votes, [:owner_id])
    create unique_index(:votes, [:option_id, :owner_id])
  end
end
