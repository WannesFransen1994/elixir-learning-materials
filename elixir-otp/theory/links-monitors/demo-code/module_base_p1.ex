defmodule Echo do
  def loop(next \\ nil) do
    receive do
      {:echo, message, from} ->
        shout_to(next, from, message)
        loop(next)

      {:update_next, new_next} ->
        loop(new_next)
    end
  end

  # ...
end
