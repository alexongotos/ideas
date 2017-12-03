defmodule IdeasWeb.Router do
  use IdeasWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :authenticated do
    plug(IdeasWeb.SessionCookiePlug)
  end

  scope "/", IdeasWeb do
    # Use the default browser stack
    pipe_through(:browser)
    pipe_through(:authenticated)

    resources("/sessions", SessionController)
    resources("/points", PointController)
    resources("/ideas", IdeaController)
    resources("/", IdeaController)
  end

  # Other scopes may use custom stacks.
  # scope "/api", IdeasWeb do
  #   pipe_through :api
  # end
end
