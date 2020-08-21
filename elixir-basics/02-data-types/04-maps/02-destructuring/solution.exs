defmodule Util do
    def follow(map, start) do
      next = map[start]

      if next do
        [ start | follow(map, next) ]
      else
        [ start ]
      end
    end
end
