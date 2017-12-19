defmodule Day14 do
  use Bitwise
  import Day10, only: [hash: 1]

  def part1(input) do
    Enum.reduce(0..127, [], fn(n, acc) ->
      ["#{input}-#{n}" | acc]
    end)
    |> Enum.reverse
    |> Enum.map(&hash/1)
    |> Enum.map(fn(h) ->
      n = h
      |> String.to_integer(16)

      Enum.reduce(0..127, [], fn(shift, acc) ->
        [(n >>> shift) &&& 1 | acc]
      end)
    end)
    |> List.flatten
    |> Enum.sum
  end

  def part2(_input) do
  end
end
