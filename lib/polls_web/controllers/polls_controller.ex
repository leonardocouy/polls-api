defmodule PollsWeb.PollsController do
  use PollsWeb, :controller

  alias Polls.Core
  alias Polls.Core.Poll

  action_fallback PollsWeb.FallbackController

  def index(conn, _params) do
    polls = Core.list_polls([:owner, :options])

    render(conn, "index.json", polls: polls)
  end

  def create(conn, %{"poll" => poll_params}) do
    with {:ok, %Poll{} = poll} <- Core.create_poll(poll_params) do
      conn
      |> put_status(:created)
      |> render("show.json", poll: poll)
    end
  end

  def show(conn, %{"id" => id}) do
    poll = Core.get_poll!(id)
    render(conn, "show.json", poll: poll)
  end

  def update(conn, %{"id" => id, "poll" => %{"question" => question}}) do
    user = conn.assigns.current_user
    poll = Core.get_poll!(id)
    update_params = %{question: question}

    with :ok <- Bodyguard.permit(Polls.PollPolicy, :update, user, poll),
         {:ok, %Poll{} = poll} <- Core.update_poll(poll, update_params)
    do
      render(conn, "show.json", poll: poll)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    poll = Core.get_poll!(id)

    with :ok <- Bodyguard.permit(Polls.PollPolicy, :delete, user, poll),
        {:ok, %Poll{}} <- Core.delete_poll(poll)
    do
      send_resp(conn, :no_content, "")
    end
  end
end
