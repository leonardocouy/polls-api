defmodule Polls.AccountsTest do
  use Polls.DataCase

  alias Polls.Accounts
  alias Polls.Accounts.User

  import Polls.AccountsFixtures

  @invalid_attrs %{email: nil, password: nil, name: nil}

  describe "list_users/0" do
    test "returns all users" do
      %User{id: user_id} = user_fixture()

      assert [%{id: ^user_id}] = Accounts.list_users()
    end
  end

  describe "get_user_by_email/1" do
    test "returns the user with given email" do
      %User{id: user_id, email: email} = user_fixture()

      assert %{id: ^user_id} = Accounts.get_user_by_email(email)
    end
  end

  describe "get_user!/1" do
    test "returns the user with given id" do
      %User{id: user_id} = user_fixture()

      assert %{id: ^user_id} = Accounts.get_user!(user_id)
    end
  end

  describe "create_user/1" do
    test "when the attrs are valid, creates a user" do
      valid_attrs = %{
        email: "test@email.com",
        password: "123456",
        name: "some name"
      }

      assert {
        :ok,
        %User{
          email: "test@email.com",
          password: "123456",
          name: "some name"
        } = user
      } = Accounts.create_user(valid_attrs)
      assert user.encrypted_password != nil
    end

    test "when the attrs are invalid, returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end
  end

  describe "update_user/2" do
    test "when attrs are valid, updates the user" do
      user = user_fixture()
      update_attrs = %{
        email: "updated_test@email.com",
        password: "777777",
        name: "updated"
      }

      assert {
        :ok,
        %User{
          email: "updated_test@email.com",
          password: "777777",
          name: "updated"
        } = user
      } = Accounts.update_user(user, update_attrs)
      assert user.password != "123456"
    end

    test "when attrs are invalid, returns error changeset" do
      (%{id: user_id} = user) = user_fixture()

      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert %{id: ^user_id} = Accounts.get_user!(user_id)
    end
  end

  describe "delete_user/1" do
    test "deletes the user" do
      user = user_fixture()

      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end
  end

  describe "change_user/1" do
    test "returns a changeset" do
      user = user_fixture()

      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "authenticate_user/2" do
    test "when given credentials are valid, returns the user" do
      %User{id: user_id, email: email} = user_fixture()

      assert {:ok, %User{id: ^user_id}} = Accounts.authenticate_user(email, "123456")
    end

    test "when given email exists but the password is invalid, returns unauthorized error" do
      %User{email: email} = user_fixture()

      assert {:error, :unauthorized} = Accounts.authenticate_user(email, "invalid_password")
    end

    test "when given email does not exists, returns user not found error" do
      assert {:error, {:not_found, "User not found"}} = Accounts.authenticate_user("invalid_email", "123456")
    end
  end
end
