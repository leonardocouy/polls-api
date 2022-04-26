defmodule PollsWeb.SessionsView do
  use PollsWeb, :view

  def render("register.json", %{user: user, token: token}) do
    %{
      message: "User created!",
      user: %{
        id: user.id,
        name: user.name,
        email: user.email
      },
      token: build_token_response(token)
    }
  end

  def render("sign_in.json", %{token: token}) do
    %{token: build_token_response(token)}
  end

  defp build_token_response({:ok, token, %{"exp" => exp}}) do
    %{access_token: token, token_type: "Bearer", expires_in: exp}
  end
end
