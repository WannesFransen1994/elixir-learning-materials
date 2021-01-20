defmodule UserCatsWeb.PageController do
  use UserCatsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
