defmodule FictiveWebserver.FactorialResultWaiter do
  use GenServer

  @me __MODULE__
  require IEx

  defstruct requests: %{}

  def start_link(_args) do
    GenServer.start_link(@me, :ignore_args, name: @me)
  end

  def wait_for_response(factorial_requested, ts_before, ts_after) do
    GenServer.call(@me, {:wait_response, factorial_requested, ts_before, ts_after})
  end

  def register_response(factorial_requested, response) do
    GenServer.cast(@me, {:register_response, factorial_requested, response})
  end

  def init(:ignore_args) do
    {:ok, %@me{}}
  end

  def handle_call({:wait_response, fact, ts_before, ts_after}, from, %@me{requests: reqs} = s) do
    new_reqs =
      case Map.get(reqs, fact) do
        # In case the factorial isn't requested yet, create an entry
        nil -> Map.put(reqs, fact, %{from => {ts_before, ts_after}})
        # In case the factorial was already requested (in the past), merge the requesters
        #  so that they both can retrieve a response.
        entry -> Map.put(reqs, fact, Map.put(entry, from, {ts_before, ts_after}))
      end

    {:noreply, %{s | requests: new_reqs}}
  end

  def handle_cast({:register_response, fact, response}, %@me{requests: reqs} = s) do
    remaining_requests =
      case Map.pop(reqs, fact) do
        {nil, reqs} ->
          reqs

        {map_with_from_pairs, remaining_reqs} ->
          Enum.each(map_with_from_pairs, fn {from, information} ->
            GenServer.reply(from, {response, information})
          end)

          remaining_reqs
      end

    {:noreply, %{s | requests: remaining_requests}}
  end
end
