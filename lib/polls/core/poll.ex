defmodule Polls.Core.Poll do
  use Ecto.Schema
  import Ecto.Changeset
  alias Polls.Accounts.User
  alias Polls.Core.Option

  schema "polls" do
    field :question, :string

    belongs_to(:owner, User)
    has_many(:options, Option, on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(poll, attrs) do
    poll
    |> cast(attrs, [:question, :owner_id])
    |> cast_assoc(:options)
    |> validate_required([:question, :owner_id])
    |> assoc_constraint(:owner)
  end
end
