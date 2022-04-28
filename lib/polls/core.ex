defmodule Polls.Core do
  @moduledoc """
  The Core context.
  """

  import Ecto.Query, warn: false
  alias Polls.Repo

  alias Polls.Core.Poll

  def list_polls do
    Repo.all(Poll)
    |> Repo.preload([:owner, :options])
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

  alias Polls.Core.Option

  def list_options do
    Repo.all(Option)
  end

  def get_option!(id), do: Repo.get!(Option, id)

  def create_option(attrs \\ %{}) do
    %Option{}
    |> Option.changeset(attrs)
    |> Repo.insert()
  end

  def update_option(%Option{} = option, attrs) do
    option
    |> Option.changeset(attrs)
    |> Repo.update()
  end

  def delete_option(%Option{} = option) do
    Repo.delete(option)
  end

  def change_option(%Option{} = option, attrs \\ %{}) do
    Option.changeset(option, attrs)
  end
end
