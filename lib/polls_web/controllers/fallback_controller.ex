defmodule PollsWeb.FallbackController do
  use PollsWeb, :controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> text("")
  end
end
