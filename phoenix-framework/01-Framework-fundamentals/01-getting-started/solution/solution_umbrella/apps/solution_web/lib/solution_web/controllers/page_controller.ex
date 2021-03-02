defmodule SolutionWeb.PageController do
  use SolutionWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def task_1(conn, _params) do
    render(conn, "task_1.html")
  end

  def task_2(conn, %{"min" => min, "max" => max}) do
    n = Solution.generate_random_number_between(min, max)
    render(conn, "task_2.html", n: n)
  end

  def task_2(conn, _params) do
    redirect(conn, to: Routes.page_path(conn, :task_2, min: 10, max: 100))
  end
end
