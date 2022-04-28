defmodule Polls.Core.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  alias Polls.Core.Option
  alias Polls.Core.User

  schema "votes" do
    belongs_to(:option, Option, on_replace: :delete)
    belongs_to(:owner, User, on_replace: :nilify)

    timestamps()
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:option_id, :owner_id])
    |> validate_required([:option_id, :owner_id])
    |> assoc_constraint(:option)
    |> assoc_constraint(:owner)
    |> unique_constraint([:option_id, :owner_id])
  end
end
