defmodule Util do
    def follow(map, start) do
      with {:ok, x} <- Map.fetch(map, start) do
        [ start | follow(map, x) ]
      else
        err -> [ start ]
      end
    end
end
