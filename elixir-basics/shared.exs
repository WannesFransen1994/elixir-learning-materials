defmodule Shared do
  require Logger

  defp format(xs) when is_list(xs) do
    xs
    |> Enum.map(&format/1)
    |> Enum.join(", ")
    |> (fn s -> "[#{s}]" end).()
  end

  defp format(x) do
    inspect(x)
  end

  defmacro check(that: block, is_equal_to: expected) do
    str = Macro.to_string(block)

    quote do
      test "#{unquote(str)} should be equal to #{unquote(format(expected))}" do
        assert unquote(block) == unquote(expected)
      end
    end
  end

  defmacro must_raise(exception, do: block) do
    str = Macro.to_string(block)

    quote do
      test "#{unquote(str)} should raise a #{unquote(format(exception))}" do
        assert_raise(unquote(exception), fn -> unquote(block) end)
      end
    end
  end

  defmacro test_function(identifier, do: block) do
    {:/, _, [{{:., _, [{_, _, [module]}, function]}, _, _}, arity]} = identifier
    module = String.to_atom("Elixir.#{module}")

    quote do
      if Kernel.function_exported?(unquote(module), unquote(function), unquote(arity)) do
        unquote(block)
      else
        flunk("Missing #{Kernel.inspect(unquote(module))}.#{unquote(function)}/#{unquote(arity)}")
      end
    end
  end

  def setup(exercise_directory) do
    ExUnit.start()

    file = System.get_env("STUDENT") || "student.exs"
    path = Path.join(exercise_directory, file)

    if not File.exists?(path) do
      Logger.error("Could not find #{file} at the attempted location: \n#{path}")
      raise "Could not find #{file} at the attempted location: \n#{path}"
    end

    Code.compile_file(file, exercise_directory)
  end
end
