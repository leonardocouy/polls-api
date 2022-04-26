defmodule Polls.CoreTest do
  use Polls.DataCase

  alias Polls.Core

  describe "polls" do
    alias Polls.Core.Poll

    import Polls.CoreFixtures

    @invalid_attrs %{question: nil}

    test "list_polls/0 returns all polls" do
      poll = poll_fixture()
      assert Core.list_polls() == [poll]
    end

    test "get_poll!/1 returns the poll with given id" do
      poll = poll_fixture()
      assert Core.get_poll!(poll.id) == poll
    end

    test "create_poll/1 with valid data creates a poll" do
      valid_attrs = %{question: "some question"}

      assert {:ok, %Poll{} = poll} = Core.create_poll(valid_attrs)
      assert poll.question == "some question"
    end

    test "create_poll/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_poll(@invalid_attrs)
    end

    test "update_poll/2 with valid data updates the poll" do
      poll = poll_fixture()
      update_attrs = %{question: "some updated question"}

      assert {:ok, %Poll{} = poll} = Core.update_poll(poll, update_attrs)
      assert poll.question == "some updated question"
    end

    test "update_poll/2 with invalid data returns error changeset" do
      poll = poll_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_poll(poll, @invalid_attrs)
      assert poll == Core.get_poll!(poll.id)
    end

    test "delete_poll/1 deletes the poll" do
      poll = poll_fixture()
      assert {:ok, %Poll{}} = Core.delete_poll(poll)
      assert_raise Ecto.NoResultsError, fn -> Core.get_poll!(poll.id) end
    end

    test "change_poll/1 returns a poll changeset" do
      poll = poll_fixture()
      assert %Ecto.Changeset{} = Core.change_poll(poll)
    end
  end

  describe "options" do
    alias Polls.Core.Option

    import Polls.CoreFixtures

    @invalid_attrs %{value: nil}

    test "list_options/0 returns all options" do
      option = option_fixture()
      assert Core.list_options() == [option]
    end

    test "get_option!/1 returns the option with given id" do
      option = option_fixture()
      assert Core.get_option!(option.id) == option
    end

    test "create_option/1 with valid data creates a option" do
      valid_attrs = %{value: "some value"}

      assert {:ok, %Option{} = option} = Core.create_option(valid_attrs)
      assert option.value == "some value"
    end

    test "create_option/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_option(@invalid_attrs)
    end

    test "update_option/2 with valid data updates the option" do
      option = option_fixture()
      update_attrs = %{value: "some updated value"}

      assert {:ok, %Option{} = option} = Core.update_option(option, update_attrs)
      assert option.value == "some updated value"
    end

    test "update_option/2 with invalid data returns error changeset" do
      option = option_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_option(option, @invalid_attrs)
      assert option == Core.get_option!(option.id)
    end

    test "delete_option/1 deletes the option" do
      option = option_fixture()
      assert {:ok, %Option{}} = Core.delete_option(option)
      assert_raise Ecto.NoResultsError, fn -> Core.get_option!(option.id) end
    end

    test "change_option/1 returns a option changeset" do
      option = option_fixture()
      assert %Ecto.Changeset{} = Core.change_option(option)
    end
  end
end
