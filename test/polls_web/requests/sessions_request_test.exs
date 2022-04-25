defmodule PollsWeb.SessionsRequestTest do
  use PollsWeb.ConnCase, async: true

  import Polls.AccountsFixtures

  describe "POST /register" do
    test "when params is valid, returns the created user with 201", %{conn: conn} do
      params = %{name: "Test", email: "test@email.com", password: "123456"}

      result = post(conn, Routes.sessions_path(conn, :register), params)

      assert result.status == 201
      assert result.resp_body != ""
    end

    # test "when params is invalid, returns bad request with errors", %{conn: conn} do
    #   params = %{}

    #   result = post(conn, Routes.sessions_path(conn, :register), params)

    #   assert result.status == 400
    #   # assert json_response(result, 400) != %{}
    # end
  end

  describe "POST /sign_in" do
    test "when params is valid, returns the user token", %{conn: conn} do
      user_fixture()
      params = %{email: "test@email.com", password: "123456"}

      result = post(conn, Routes.sessions_path(conn, :sign_in), params)

      assert result.status == 200
      assert result.resp_body != ""
    end

    # test "when params is invalid, returns bad request with errors", %{conn: conn} do
    #   params = %{}

    #   result = post(conn, Routes.sessions_path(conn, :register), params)

    #   assert result.status == 400
    #   # assert json_response(result, 400) != %{}
    # end
  end
end
