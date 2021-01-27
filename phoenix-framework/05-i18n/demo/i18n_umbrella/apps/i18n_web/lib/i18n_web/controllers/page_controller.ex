defmodule I18nWeb.PageController do
  use I18nWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def another_index(conn, _params) do
    render(conn, "another_index.html")
  end

  def perform_some_logic(conn, %{"max" => max}) do
    {max_parsed, _} = Integer.parse(max)

    case I18n.random_string(max_parsed) do
      {:ok, password} ->
        render(conn, "password_display.html", password: password)

      {:error, message} ->
        conn |> put_flash(:error, message) |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def perform_some_logic(conn, _params) do
    redirect(conn, to: Routes.page_path(conn, :perform_some_logic, max: 50))
  end
end
