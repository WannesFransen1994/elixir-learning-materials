defmodule UserDemoWeb.PageController do
  use UserDemoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
