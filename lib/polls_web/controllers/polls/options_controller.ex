defmodule PollsWeb.Polls.OptionsController do
  use PollsWeb, :controller

  alias Polls.Core

  action_fallback PollsWeb.FallbackController

  def index(conn, %{"poll_id" => poll_id}) do
    options = Core.list_poll_options_by_poll_id(poll_id)

    render(conn, "index.json", options: options)
  end
end
