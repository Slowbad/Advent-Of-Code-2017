defmodule Day19 do
  @doc """
  #    iex> Day19.part1("     |          \\n     |  +--+    \\n     A  |  C    \\n F---|----E|--+ \\n     |  |  |  D \\n     +B-+  +--+")
      "ABCDEF"
  """
  def part1(input) do
    path = input |> parse_input

    path
    |> walk(find_start(path), :down, [])
    |> Enum.reverse
    |> Enum.join
  end

  def part2(_) do
  end

  def walk(path, pos, direction, letters) do
    case path[pos] do
      nil ->
        letters
      :line ->
        walk(path, step(direction, pos), direction, letters)
      :corner ->
        new_dir = turn(path, pos, direction)
        walk(path, step(new_dir, pos), new_dir, letters)
      letter ->
        walk(path, step(direction, pos), direction, [letter | letters])
    end
  end

  def step(:up, {x, y}), do: {x, y - 1}
  def step(:down, {x, y}), do: {x, y + 1}
  def step(:left, {x, y}), do: {x - 1, y}
  def step(:right, {x, y}), do: {x + 1, y}



  @doc """
      iex> Day19.turn(%{{5, 4} => :line, {5, 5} => :corner, {6, 5} => :line}, {5, 5}, :down)
      :right
  """
  def turn(path, position, direction) do
    case direction do
      :up -> [:left, :right]
      :down -> [:left, :right]
      :left -> [:up, :down]
      :right -> [:up, :down]
    end
    |> Enum.find(fn(dir) ->
      path[step(dir, position)]
    end)
  end


  @doc """
      iex> Day19.find_start(%{{2, 0} => :line, {2, 1} => "A", {1, 2} => :line, {2, 2} => :corner})
      {2, 0}
  """
  def find_start(path) do
    path
    |> Enum.filter(fn
      ({{_, 0}, _}) -> true
      ({_, _}) -> false
    end)
    |> hd
    |> elem(0)
  end

  @doc """
      iex> Day19.parse_input("  | \\n  A \\n -+ ")
      %{{2, 0} => :line, {2, 1} => "A", {1, 2} => :line, {2, 2} => :corner}
  """
  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.reduce({%{}, 0}, fn(line, {outer, row}) ->
      {outer, _} = line
      |> String.graphemes
      |> Enum.reduce({outer, 0}, fn
        (" ", {inner, col}) -> {inner, col + 1}
        ("+", {inner, col}) -> {Map.put(inner, {col, row}, :corner), col + 1}
        ("|", {inner, col}) -> {Map.put(inner, {col, row}, :line), col + 1}
        ("-", {inner, col}) -> {Map.put(inner, {col, row}, :line), col + 1}
        (letter, {inner, col}) -> {Map.put(inner, {col, row}, letter), col + 1}
      end)
      {outer, row + 1}
    end)
    |> elem(0)
  end
end
