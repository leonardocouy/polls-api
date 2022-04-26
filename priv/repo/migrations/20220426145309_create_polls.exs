defmodule Polls.Repo.Migrations.CreatePolls do
  use Ecto.Migration

  def change do
    create table(:polls) do
      add :question, :string, null: false
      add :owner_id, references(:users, on_delete: :nilify_all)

      timestamps()
    end

    create index(:polls, [:owner_id])
  end
end
