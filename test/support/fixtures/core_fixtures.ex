defmodule Polls.CoreFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Polls.Core` context.
  """

  alias Polls.AccountsFixtures

  def poll_fixture(attrs \\ %{}) do
    {:ok, poll} =
      build_poll_attrs(attrs)
      |> Polls.Core.create_poll()

    poll
  end

  def poll_with_options_fixture(attrs \\ %{}) do
    {:ok, poll} =
      build_poll_attrs(attrs)
      |> Enum.into(%{
        options: [
          %{value: "Pizza"},
          %{value: "Salad"},
          %{value: "Chocolate"}
        ]
      })
      |> Polls.Core.create_poll()

    poll
  end

  def option_fixture(attrs \\ %{}) do
    {:ok, option} =
      attrs
      |> Enum.into(%{
        value: "some value"
      })
      |> Polls.Core.create_option()

    option
  end

  defp build_poll_attrs(attrs \\ %{}) do
    %{id: user_id} = AccountsFixtures.user_fixture()

    attrs
    |> Enum.into(%{
      question: "Which one is your favourite food?",
      owner_id: user_id
    })
  end
end
