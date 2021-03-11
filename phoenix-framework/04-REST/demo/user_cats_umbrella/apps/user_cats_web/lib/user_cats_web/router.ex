defmodule UserCatsWeb.Router do
  use UserCatsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UserCatsWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController
  end

  scope "/api", UserCatsWeb do
    pipe_through :api

    resources "/users", UserController, only: [] do
      resources "/cats", CatController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", UserCatsWeb do
  #   pipe_through :api
  # end
end
