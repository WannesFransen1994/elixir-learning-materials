defmodule StudentWeb.RandomController do
  use StudentWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", number: Student.random_number())
  end
end
