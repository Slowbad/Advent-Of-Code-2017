defmodule Day21 do
  @initial_pattern [[".", "#", "."], [".", ".", "#"], ["#", "#", "#"]]

  def part1(input) do
    urg(input, 5)
  end

  def part2(input) do
    urg(input, 18)
  end

  def urg(input, iterations) do
    enhancements = input |> parse_input

    run(@initial_pattern, enhancements, iterations)
    |> List.flatten
    |> Enum.count(fn(pixel) -> pixel == "#" end)
  end

  def run(pattern, _enhancements, iter) when iter == 0, do: pattern
  def run(pattern, enhancements, iter) do
    block_size = if rem(pattern |> hd |> length, 2) == 0, do: 2, else: 3

    pattern
    |> break_grid(block_size)
    |> replace_blocks(enhancements)
    |> reassemble_grid(block_size)
    |> run(enhancements, iter - 1)
  end

  def replace_blocks(blocks, enhancements) do
    blocks
    |> Enum.map(fn(block_set) ->
      Enum.map(block_set, fn(block) -> enhancements[block] end)
    end)
  end

  def parse_input(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn(line) ->
      line
      |> String.split(" => ")
      |> Enum.map(&raw_to_block/1)
    end)
    |> Enum.reduce(%{}, fn([from, to], acc) ->
      acc
      |> Map.put(from, to)
      |> Map.put(from |> rotate, to)
      |> Map.put(from |> rotate |> rotate, to)
      |> Map.put(from |> rotate |> rotate |> rotate, to)
      |> Map.put(from |> flip, to)
      |> Map.put(from |> flip |> rotate, to)
      |> Map.put(from |> flip |> rotate |> rotate, to)
      |> Map.put(from |> flip |> rotate |> rotate |> rotate, to)
    end)
  end

  @doc """
      iex> Day21.raw_to_block("#./..")
      {["#", "."], [".", "."]}
  """
  def raw_to_block(raw) do
    raw
    |> String.split("/")
    |> Enum.map(&String.split(&1, "", trim: true))
    |> List.to_tuple
  end

  @doc """
      iex> Day21.construct_blocks(["#", ".",  ".", "#"], [".", ".", ".", "."])
      [{["#", "."], [".", "."]}, {[".", "#"], [".", "."]}]

      iex> Day21.construct_blocks(["#", "#", ".", ".", "#", "#"], ["#", ".", ".", ".", ".", "#"], [".", ".", ".", ".", ".", "."])
      [{["#", "#", "."], ["#", ".", "."], [".", ".", "."]}, {[".", "#", "#"], [".", ".", "#"], [".", ".", "."]}]
  """
  def construct_blocks(a, b, c) do
    Enum.zip([Enum.chunk(a, 3), Enum.chunk(b, 3), Enum.chunk(c, 3)])
  end
  def construct_blocks(a, b) do
    Enum.zip([Enum.chunk(a, 2), Enum.chunk(b, 2)])
  end

  @doc """
      iex> Day21.break_grid([["#", ".", ".", "#"], [".", ".", ".", "."], [".", ".", ".", "."], ["#", ".", ".", "#"]], 2)
      [[{["#", "."], [".", "."]}, {[".", "#"], [".", "."]}], [{[".", "."], ["#", "."]}, {[".", "."], [".", "#"]}]]
  """
  def break_grid([], _block_size), do: []
  def break_grid([a, b | rest], block_size) when block_size == 2 do
    [construct_blocks(a, b) | break_grid(rest, block_size)]
  end
  def break_grid([a, b, c | rest], block_size) when block_size == 3 do
    [construct_blocks(a, b, c) | break_grid(rest, block_size)]
  end

  def deconstruct_blocks(blocks, old_block_size) when old_block_size == 2 do
    blocks
    |> Enum.reduce([[], [], []], fn({a, b, c}, [x, y, z]) ->
      [x ++ a, y ++ b, z ++ c]
    end)
  end
  def deconstruct_blocks(blocks, old_block_size) when old_block_size == 3 do
    blocks
    |> Enum.reduce([[], [], [], []], fn({a, b, c, d}, [w, x, y, z]) ->
      [w ++ a, x ++ b, y ++ c, z ++ d]
    end)
  end

  @doc """
      iex> Day21.reassemble_grid([[{["#", ".", ".", "."], [".", "#", ".", "."], [".", ".", "#", "."], [".", ".", ".", "#"]}]], 3)
      [["#", ".", ".", "."], [".", "#", ".", "."], [".", ".", "#", "."], [".", ".", ".", "#"]]
  """
  def reassemble_grid([], _block_size), do: []
  def reassemble_grid([block_list | rest], block_size) do
    deconstruct_blocks(block_list, block_size) ++ reassemble_grid(rest, block_size)
  end

  @doc """
  Parameters are named and ordered to make it easier to understand where they
  are moving to after the rotation.

      iex> Day21.rotate({["#", "."], [".", "#"]})
      {[".", "#"], ["#", "."]}

      iex> Day21.rotate({[".", "#", "."], [".", ".", "#"], ["#", "#", "#"]})
      {["#", ".", "."], ["#", ".", "#"], ["#", "#", "."]}
  """
  def rotate({[a, b], [d, c]}) do
    {[d, a], [c, b]}
  end
  def rotate({[a, b, c], [h, center, d], [g, f, e]}) do
    {[g, h, a], [f, center, b], [e, d, c]}
  end

  def flip(block) do
    block
    |> Tuple.to_list
    |> Enum.map(&Enum.reverse/1)
    |> List.to_tuple
  end
end
