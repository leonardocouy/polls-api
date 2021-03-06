defmodule Polls.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Polls.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "test@email.com",
        password: "123456",
        name: "some name"
      })
      |> Polls.Accounts.create_user()

    user
  end
end
