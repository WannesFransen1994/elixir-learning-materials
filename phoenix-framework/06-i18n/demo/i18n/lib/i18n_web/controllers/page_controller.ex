defmodule I18nWeb.PageController do
  use I18nWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def another_index(conn, _params) do
    render(conn, "another_index.html")
  end
end
