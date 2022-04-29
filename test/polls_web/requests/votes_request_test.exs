defmodule PollsWeb.VotesRequestTest do
  use PollsWeb.ConnCase, async: true

  import Polls.CoreFixtures

  alias Polls.Core.Option, as: PollOption
  alias Polls.Repo

  describe "POST /polls/:poll_id/vote" do
    setup [:create_poll]

    test "when params is valid, returns a successful response", %{conn: conn, poll: poll} do
      %{id: id, owner: poll_owner} = poll
      pizza_option = Repo.get_by(PollOption, %{poll_id: id, value: "Pizza"})
      vote_params = %{
        option_id: pizza_option.id,
        owner_id: poll_owner.id
      }

      result =
        conn
        |> login(poll_owner)
        |> post(Routes.polls_votes_path(conn, :create, id), vote: vote_params)

      assert result.status == 201
    end

    test "when params is invalid, returns bad request with errors", %{conn: conn, poll: poll} do
      %{id: id, owner: poll_owner} = poll

      result =
        conn
        |> login(poll_owner)
        |> post(Routes.polls_votes_path(conn, :create, id), vote: %{})

      assert result.status == 400
      assert json_response(result, 400) == %{
        "message" => %{
          "owner_id" => ["can't be blank"],
          "option_id" => ["can't be blank"]
        }
      }
    end

    test "when the user is not authenticated, returns 401", %{conn: conn, poll: %{id: id}} do
      result = post(conn, Routes.polls_votes_path(conn, :create, id), vote: %{})

      assert %Plug.Conn{status: 401} = result
    end
  end

  defp create_poll(_ctx) do
    [poll: poll_with_options_fixture()]
  end
end
