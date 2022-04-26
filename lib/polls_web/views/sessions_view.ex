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
      token: token
    }
  end

  def render("sign_in.json", %{token: token}) do
    %{token: token}
  end
end
