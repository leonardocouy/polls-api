defmodule PollsWeb.PollsRequestTest do
  use PollsWeb.ConnCase, async: true

  import Polls.CoreFixtures
  import Polls.AccountsFixtures

  describe "GET /polls" do
    setup [:create_poll]

    test "returns a list containing all polls including the owner and options", %{conn: conn, poll: poll} do
      %{id: id, question: question, owner: %{id: owner_id}} = poll

      result =
        conn
        |> login(poll.owner)
        |> get(Routes.polls_path(conn, :index))

      assert result.status == 200
      assert [
        %{
          "created_at" => _,
          "id" => ^id,
          "options" => [
            %{"id" => _, "value" => "Pizza", "vote_count" => 0},
            %{"id" => _, "value" => "Salad", "vote_count" => 0},
            %{"id" => _, "value" => "Chocolate", "vote_count" => 0}
          ],
          "owner" => %{"id" => ^owner_id, "name" => "some name"},
          "question" => ^question,
          "updated_at" => _
        }
      ] = json_response(result, 200)["data"]
    end

    test "when the user is not authenticated, returns 401", %{conn: conn} do
      result = post(conn, Routes.polls_path(conn, :index))

      assert %Plug.Conn{status: 401} = result
    end
  end

  describe "POST /polls" do
    test "when params is valid, returns the created poll with 201", %{conn: conn} do
      (%{id: user_id} = user) = user_fixture()
      create_attrs = %{
        question: "Which one is your favourite food?",
        owner_id: user_id,
        options: [
          %{value: "Pizza"},
          %{value: "Salad"},
          %{value: "Chocolate"}
        ]
      }

      result =
        conn
        |> login(user)
        |> post(Routes.polls_path(conn, :create), poll: create_attrs)

      assert result.status == 201
      assert %{
        "created_at" => _,
        "id" => _,
        "options" => [
          %{"id" => _, "value" => "Pizza"},
          %{"id" => _, "value" => "Salad"},
          %{"id" => _, "value" => "Chocolate"}
        ],
        "owner" => %{"id" => ^user_id, "name" => "some name"},
        "question" => "Which one is your favourite food?",
        "updated_at" => _
      } = json_response(result, 201)["data"]
    end

    test "when params is invalid, returns bad request with errors", %{conn: conn} do
      user = user_fixture()

      result =
        conn
        |> login(user)
        |> post(Routes.polls_path(conn, :create), poll: %{})

      assert result.status == 400
      assert json_response(result, 400) == %{
        "message" => %{
          "question" => ["can't be blank"],
          "owner_id" => ["can't be blank"],
        }
      }
    end

    test "when the user is not authenticated, returns 401", %{conn: conn} do
      result = post(conn, Routes.polls_path(conn, :create), poll: %{})

      assert %Plug.Conn{status: 401} = result
    end
  end

  describe "PUT /polls/:id" do
    setup [:create_poll]

    test "when params is valid, returns the updated poll with 200", %{conn: conn, poll: poll} do
      %{id: poll_id} = poll
      update_attrs = %{
        question: "Which one is the most expensive food?",
      }

      result =
        conn
        |> login(poll.owner)
        |> put(Routes.polls_path(conn, :update, poll_id), poll: update_attrs)

      assert result.status == 200
      assert %{
        "created_at" => _,
        "id" => ^poll_id,
        "options" => [
          %{"id" => _, "value" => "Pizza"},
          %{"id" => _, "value" => "Salad"},
          %{"id" => _, "value" => "Chocolate"}
        ],
        "owner" => %{"id" => _, "name" => "some name"},
        "question" => "Which one is the most expensive food?",
        "updated_at" => _
      } = json_response(result, 200)["data"]
    end

    test "when params is invalid, returns bad request with errors", %{conn: conn, poll: poll} do
      %{id: poll_id} = poll
      update_attrs = %{question: nil}

      result =
        conn
        |> login(poll.owner)
        |> put(Routes.polls_path(conn, :update, poll_id), poll: update_attrs)

      assert result.status == 400
      assert json_response(result, 400) == %{
        "message" => %{
          "question" => ["can't be blank"],
        }
      }
    end

    test "when the user is not authenticated, returns 401", %{conn: conn, poll: %{id: poll_id}} do
      result = put(conn, Routes.polls_path(conn, :update, poll_id), %{})

      assert %Plug.Conn{status: 401} = result
    end
  end

  describe "DELETE /polls/:id" do
    setup [:create_poll]

    test "deletes chosen poll", %{conn: conn, poll: poll} do
      %{id: poll_id} = poll

      conn = conn
        |> login(poll.owner)
        |> delete(Routes.polls_path(conn, :delete, poll_id))

      assert response(conn, 204)
    end

    test "when the user is not authenticated, returns 401", %{conn: conn, poll: %{id: poll_id}} do
      result = delete(conn, Routes.polls_path(conn, :delete, poll_id))

      assert %Plug.Conn{status: 401} = result
    end
  end

  defp create_poll(_ctx) do
    [poll: poll_with_options_fixture()]
  end
end
