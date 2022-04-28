defmodule PollsWeb.Polls.VotesController do
  use PollsWeb, :controller

  alias Polls.Core
  alias Polls.Core.Vote, as: PollOptionVote

  action_fallback PollsWeb.FallbackController

  def create(conn, %{"poll_id" => _, "vote" => vote_params}) do
    with {:ok, %PollOptionVote{}} <- Core.create_vote(vote_params) do
      conn
      |> put_status(:created)
      |> text("")
    end
  end
end
