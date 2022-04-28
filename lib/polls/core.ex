defmodule Polls.Core do
  @moduledoc """
  The Core context.
  """

  import Ecto.Query, warn: false
  alias Polls.Repo

  alias Polls.Core.Option, as: PollOption
  alias Polls.Core.Poll

  def list_polls(preloads \\ []) do
    Poll
    |> preload(^preloads)
    |> Repo.all()
  end

  def get_poll!(id), do: Repo.get!(Poll, id) |> Repo.preload([:owner, :options])

  def create_poll(attrs \\ %{}) do
    %Poll{}
    |> Poll.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, %Poll{} = poll} -> {:ok, Repo.preload(poll, [:owner, :options])}
      error -> error
    end
  end

  def update_poll(%Poll{} = poll, attrs) do
    poll
    |> Poll.changeset(attrs)
    |> Repo.update()
  end

  def delete_poll(%Poll{} = poll) do
    Repo.delete(poll)
  end

  def change_poll(%Poll{} = poll, attrs \\ %{}) do
    Poll.changeset(poll, attrs)
  end

  def list_poll_options do
    Repo.all(PollOption)
  end

  def list_poll_options_by_poll_id(poll_id) do
    PollOption
    |> where(poll_id: ^poll_id)
    |> Repo.all()
  end

  def get_poll_option!(id), do: Repo.get!(PollOption, id)

  def create_poll_option(attrs \\ %{}) do
    %PollOption{}
    |> PollOption.changeset(attrs)
    |> Repo.insert()
  end

  def update_poll_option(%PollOption{} = option, attrs) do
    option
    |> PollOption.changeset(attrs)
    |> Repo.update()
  end

  def delete_poll_option(%PollOption{} = option) do
    Repo.delete(option)
  end

  def change_poll_option(%PollOption{} = option, attrs \\ %{}) do
    PollOption.changeset(option, attrs)
  end
end
