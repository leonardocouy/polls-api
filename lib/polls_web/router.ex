defmodule PollsWeb.Router do
  use PollsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PollsWeb do
    pipe_through :api

    post "/register", SessionsController, :register
    post "/sign_in", SessionsController, :sign_in

    resources "/polls", PollsController, except: [:new, :edit], name: :poll do
      resources "/vote", Polls.VotesController, only: [:create], singleton: true
      resources "/options", Polls.OptionsController, only: [:index], name: :option
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: PollsWeb.Telemetry
    end
  end
end
