defmodule Day11 do
    def part1(input) do
        input
        |> String.trim
        |> String.split(",")
        |> Enum.map(&String.to_atom/1)
        |> Enum.reduce({0, 0, 0}, fn 
            (:n,  {x, y, z}) -> {x    , y + 1, z - 1}
            (:ne, {x, y, z}) -> {x + 1, y    , z - 1}
            (:se, {x, y, z}) -> {x + 1, y - 1, z    }
            (:s,  {x, y, z}) -> {x    , y - 1, z + 1}
            (:sw, {x, y, z}) -> {x - 1, y    , z + 1}
            (:nw, {x, y, z}) -> {x - 1, y + 1, z    }
        end)
        |> cube_distance({0, 0, 0})
    end

    def cube_distance({ax, ay, az}, {bx, by, bz}) do
        div(abs(ax - bx) + abs(ay - by) + abs(az - bz), 2)
    end

    def part2(_input) do

    end
end