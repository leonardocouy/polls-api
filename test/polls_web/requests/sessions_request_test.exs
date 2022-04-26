defmodule PollsWeb.SessionsRequestTest do
  use PollsWeb.ConnCase, async: true

  import Polls.AccountsFixtures

  describe "POST /register" do
    test "when params is valid, returns the created user with 201", %{conn: conn} do
      params = %{name: "Test", email: "test@email.com", password: "123456"}

      result = post(conn, Routes.sessions_path(conn, :register), params)

      assert result.status == 201
      assert %{
        "message" => "User created!",
        "user" => %{"id" => _id, "name" => "Test", "email" => "test@email.com"},
        "token" => %{
          "access_token" => _access_token,
          "expires_in" => _expires_in,
          "token_type" => "Bearer"
        }
      } = json_response(result, 201)
    end

    test "when params is invalid, returns bad request with errors", %{conn: conn} do
      params = %{}

      result = post(conn, Routes.sessions_path(conn, :register), params)

      assert result.status == 400
      assert json_response(result, 400) == %{
        "message" => %{
          "email" => ["can't be blank"],
          "name" => ["can't be blank"],
          "password" => ["can't be blank"]
        }
      }
    end
  end

  describe "POST /sign_in" do
    test "when params is valid, returns the user token", %{conn: conn} do
      user_fixture()
      params = %{email: "test@email.com", password: "123456"}

      result = post(conn, Routes.sessions_path(conn, :sign_in), params)

      assert result.status == 200
      assert %{
        "token" => %{
          "access_token" => _access_token,
          "expires_in" => _expires_in,
          "token_type" => "Bearer"
        }
      } = json_response(result, 200)
    end

    test "when the user password is wrong, returns 401", %{conn: conn} do
      user_fixture()
      params = %{email: "test@email.com", password: "123x456"}

      result = post(conn, Routes.sessions_path(conn, :sign_in), params)

      assert %Plug.Conn{status: 401} = result
    end
  end
end
