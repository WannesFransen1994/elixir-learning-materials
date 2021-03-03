defmodule SolutionWeb.PageController do
  use SolutionWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  #Render task_1.html.eex file van de template folder
  def task_1(conn, _params) do
    render(conn, "task_1.html")
  end

  #Pattern match op min en max parameters die via de get request worden meegegeven.
  def task_2(conn, %{"min" => min, "max" => max} = _params) do
    number = Solution.generate_random_number_between(min, max)
    # Via render kunnen we variabelen meegeven die in de template gebruikt kunnen worden. number wordt gebruikt in de task2.html.eex te vinden in templates/page/task2.html.eex)
    # voor 'templates/<naam>' moet <naam> overen komen met de <naam>Controller

    #De render functie gaat via de view naar de template om een html template te renderen
    render(conn, "task_2.html", number: number)
  end

  def task_2(conn, _params) do
    # Redirect start een nieuwe request. In dit geval naar page_path (omdat de get request in de router.ex file naar de pageController verwijst)
    # Later zullen nested routes gezien worden en dan kun je  Routes.page_user_path/2 hebben.
    # Het bekijken van de bestaande routes kan via de terminal gedaan worden met volgend commando: "mix phx.routes" in de myapp/apps/myapp_web folder
    redirect(conn, to: Routes.page_path(conn, :task_2, min: 10, max: 100))
  end
end
