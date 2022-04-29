defmodule PollsWeb.FallbackController do
  use PollsWeb, :controller

  def call(conn, {:error, {:not_found, message}}) do
    conn
    |> put_status(:not_found)
    |> json(%{message: message})
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:forbidden)
    |> text("")
  end

  def call(conn, {:error, result}) do
    conn
    |> put_status(:bad_request)
    |> put_view(PollsWeb.ErrorView)
    |> render("400.json", result: result)
  end
end
