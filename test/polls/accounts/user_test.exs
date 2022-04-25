defmodule Polls.UserTest do
  use Polls.DataCase

  alias Polls.Accounts.User

  import Polls.AccountsFixtures

  describe "changeset/1" do
    test "when given params is valid, returns a valid changeset" do
      params = %{
        email: "test@email.com",
        password: "123456",
        name: "some name"
      }

      changeset = User.changeset(%User{}, params)

      assert changeset.valid?
      assert %{
        email: "test@email.com",
        password: "123456",
        name: "some name"
      } = changeset.changes
      assert changeset.changes.encrypted_password != nil
    end

    test "when given params contains email with extra spaces and uppercase chars, sanitize and returns a valid changeset" do
      params = %{
        name: "some name",
        email: " TEsT@email.cOm   ",
        password: "123456"
      }

      changeset = User.changeset(%User{}, params)

      assert changeset.valid?
      assert %{
        email: "test@email.com",
        password: "123456",
        name: "some name"
      } = changeset.changes
    end

    @required_params  [:name, :email, :password]
    Enum.each(@required_params, fn required_param_name ->
      @required_param_name required_param_name

      test "when given #{required_param_name} is not present in the params, returns an invalid changeset" do
        params = %{
          email: "test@email.com",
          password: "123456",
          name: "some name"
        }

        changeset = User.changeset(%User{}, %{params | @required_param_name => nil})

        refute changeset.valid?
        assert errors_on(changeset) == %{@required_param_name => ["can't be blank"]}
      end
    end)

    test "when given email is not in a valid format, returns an invalid changeset" do
      params = %{
        email: "invalidemail",
        password: "123456",
        name: "some name"
      }

      changeset = User.changeset(%User{}, params)

      refute changeset.valid?
      assert errors_on(changeset) == %{email: ["must have the @ sign and no spaces"]}
    end

    test "when given password has length less than 6, returns an invalid changeset" do
      params = %{
        email: "test@email.com",
        password: "123",
        name: "some name"
      }

      changeset = User.changeset(%User{}, params)

      refute changeset.valid?
      assert errors_on(changeset) == %{password: ["should be at least 6 character(s)"]}
    end

    test "when given email already exists, returns an invalid changeset" do
      %User{email: email} = user_fixture()
      params = %{
        email: email,
        password: "123456",
        name: "some name"
      }

      changeset = User.changeset(%User{}, params)

      refute changeset.valid?
      assert errors_on(changeset) == %{email: ["has already been taken"]}
    end
  end
end
