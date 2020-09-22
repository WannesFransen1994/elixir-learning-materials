defmodule Exercise.Sage do
  def say_wise_thing, do: "All life must be respected!"
  def spill_secret, do: Application.fetch_env!(:exercise, :secret)
end
