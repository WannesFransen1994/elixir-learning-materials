defmodule ExtraMany2ManyUsageExampleWeb.PageController do
  use ExtraMany2ManyUsageExampleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
