defmodule PollsWeb.SessionsController do
  use PollsWeb, :controller

  alias Polls.Accounts
  alias Polls.Auth.Guardian

  action_fallback PollsWeb.FallbackController

  def register(conn, params) do
    with {:ok, user} <- Accounts.create_user(params),
         token <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("register.json", user: user, token: token)
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    with {:ok, user} <- Accounts.authenticate_user(email, password),
         token <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:ok)
      |> render("sign_in.json", token: token)
    end
  end
end
