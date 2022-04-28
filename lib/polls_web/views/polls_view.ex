defmodule PollsWeb.PollsView do
  use PollsWeb, :view

  alias Polls.Accounts.User

  def render("index.json", %{polls: polls}) do
    %{data: render_many(polls, __MODULE__, "poll.json", as: :poll)}
  end

  def render("show.json", %{poll: poll}) do
    %{data: render_one(poll, __MODULE__, "poll.json", as: :poll)}
  end

  def render("poll.json", %{poll: poll}) do
    %{
      id: poll.id,
      question: poll.question,
      owner: build_owner(poll.owner),
      options: build_options(poll.options),
      created_at: poll.inserted_at,
      updated_at: poll.inserted_at
    }
  end

  defp build_owner(owner) do
    case owner do
      %User{} -> %{id: owner.id, name: owner.name}
      nil -> nil
    end
  end

  defp build_options(options) do
    options
    |> Enum.map(fn opt ->
      %{
        id: opt.id,
        value: opt.value
      }
    end)
  end
end
