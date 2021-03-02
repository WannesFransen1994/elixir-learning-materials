defmodule SolutionWeb.Router do
  use SolutionWeb, :router

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

  scope "/", SolutionWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/task_1", PageController, :task_1)
    get("/task_2", PageController, :task_2)
  end

  # Other scopes may use custom stacks.
  # scope "/api", SolutionWeb do
  #   pipe_through :api
  # end
end
