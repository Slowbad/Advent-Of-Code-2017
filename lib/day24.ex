defmodule Day24 do
  def part1(input) do
    input
    |> parse_input
    |> find_max_strength()
  end

  def part2(_input) do
  end

  def parse_input(input) do
    input
    |> String.trim
    |> String.split
    |> Enum.map(fn(line) ->
      line
      |> String.split("/")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple
    end)
  end

  @doc """
      iex> Day24.find_max_strength([{0, 4}], 0, 0)
      4

      iex> Day24.find_max_strength([{0, 3}, {7, 3}, {7, 4}], 0, 0)
      24
  """
  def find_max_strength(components), do: find_max_strength(components, 0, 0)
  def find_max_strength(components, strength, next_port) do
    components
    |> Enum.filter(fn
      ({a, b}) -> a == next_port or b == next_port
    end)
    |> Enum.map(fn
      ({a, b} = c) when a == next_port -> find_max_strength(List.delete(components, c), a + b, b)
      ({a, b} = c) when b == next_port -> find_max_strength(List.delete(components, c), a + b, a)
    end)
    |> Enum.max(fn -> 0 end)
    |> Kernel.+(strength)
  end
end
