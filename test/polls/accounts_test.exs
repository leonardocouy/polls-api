defmodule Polls.AccountsTest do
  use Polls.DataCase

  alias Polls.Accounts

  describe "users" do
    alias Polls.Accounts.User

    import Polls.AccountsFixtures

    @invalid_attrs %{email: nil, encrypted_password: nil, name: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{
        email: "test@email.com",
        encrypted_password: "some encrypted_password",
        name: "some name"
      }

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.email == "test@email.com"
      assert user.encrypted_password == "some encrypted_password"
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      update_attrs = %{
        email: "updated_test@email.com",
        encrypted_password: "some updated encrypted_password",
        name: "some updated name"
      }

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.email == "updated_test@email.com"
      assert user.encrypted_password == "some updated encrypted_password"
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
