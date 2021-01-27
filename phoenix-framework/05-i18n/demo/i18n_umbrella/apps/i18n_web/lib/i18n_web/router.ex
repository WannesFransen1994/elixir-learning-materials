defmodule I18nWeb.Router do
  use I18nWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug I18nWeb.Plugs.Locale
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", I18nWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/another_index", PageController, :another_index
    get "/perform_some_logic", PageController, :perform_some_logic
  end

  # Other scopes may use custom stacks.
  # scope "/api", I18nWeb do
  #   pipe_through :api
  # end
end
