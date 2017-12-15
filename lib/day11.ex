defmodule Day11 do
    def part1(input) do
        input
        |> parse_input
        |> Enum.reduce({0, 0, 0}, &move/2)
        |> cube_distance({0, 0, 0})
    end

    def parse_input(input) do
        input
        |> String.trim
        |> String.split(",")
        |> Enum.map(&String.to_atom/1)
    end

    def move(:n,  {x, y, z}), do: {x    , y + 1, z - 1}
    def move(:ne, {x, y, z}), do: {x + 1, y    , z - 1}
    def move(:se, {x, y, z}), do: {x + 1, y - 1, z    }
    def move(:s,  {x, y, z}), do: {x    , y - 1, z + 1}
    def move(:sw, {x, y, z}), do: {x - 1, y    , z + 1}
    def move(:nw, {x, y, z}), do: {x - 1, y + 1, z    }

    def cube_distance({ax, ay, az}, {bx, by, bz}) do
        div(abs(ax - bx) + abs(ay - by) + abs(az - bz), 2)
    end

    def part2(input) do
        input
        |> parse_input
        |> Enum.reduce({{0, 0, 0}, 0}, fn(direction, {location, farthest}) ->
            new_loc = move(direction, location)
            distance_from_home = cube_distance(new_loc, {0, 0, 0})
            {new_loc, if(distance_from_home > farthest, do: distance_from_home, else: farthest)}
        end)
        |> elem(1)
    end
end