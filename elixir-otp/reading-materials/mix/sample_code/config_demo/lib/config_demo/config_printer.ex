defmodule ConfigDemo.ConfigPrinter do
  use GenServer

  def start_link(args \\ []), do: GenServer.start_link(__MODULE__, args)

  def init(_) do
    :timer.send_interval(2000, :print_some_config)
    {:ok, :not_important_state}
  end

  def handle_info(:print_some_config, _state) do
    IO.puts("Loaded endpoint: " <> Application.fetch_env!(:config_demo, :api_endpoint))
    {:noreply, :not_important_state}
  end
end
