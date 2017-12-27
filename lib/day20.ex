defmodule Day20 do
  @doc """
      iex> Day20.part1("p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>\\np=< 4,0,0>, v=< 0,0,0>, a=<-2,0,0>")
      0
  """
  def part1(input) do
    vectors = input
    |> parse_input

    winner = vectors
    |> Enum.min_by(fn({_, _, acceleration}) -> manhattan_distance(acceleration) end)

    vectors
    |> Enum.find_index(fn(vector) -> vector == winner end)
  end

  def part2(_) do
  end

  # Assumes distance to 0, 0, 0
  def manhattan_distance({x, y, z}) do
    abs(x) + abs(y) + abs(z)
  end

  def parse_input(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&line/1)
  end

  @doc """
      iex> Day20.line("p=<1,2,3>, v=<-1,-2,-3>, a=<0,0,0>")
      {{1, 2, 3}, {-1, -2, -3}, {0, 0, 0}}
  """
  def line(l) do
    l
    |> String.split(", ")
    |> Enum.map(fn(vector) ->
      Regex.scan(~r/-?\d+/, vector)
      |> List.flatten
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple
    end)
    |> List.to_tuple
  end
end
