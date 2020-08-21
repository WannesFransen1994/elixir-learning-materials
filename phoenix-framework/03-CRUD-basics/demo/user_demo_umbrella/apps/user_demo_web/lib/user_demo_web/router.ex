defmodule UserDemoWeb.Router do
  use UserDemoWeb, :router

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

  scope "/", UserDemoWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/users", UserController, :index
    get "/users/new", UserController, :new
    get "/users/:user_id", UserController, :show
    get "/users/:user_id/edit", UserController, :edit
    put "/users/:user_id", UserController, :update
    patch "/users/:user_id", UserController, :update
    delete "/users/:user_id", UserController, :delete
    post "/users", UserController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", UserDemoWeb do
  #   pipe_through :api
  # end
end
