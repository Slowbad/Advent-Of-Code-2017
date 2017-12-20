defmodule Day14 do
  use Bitwise
  import Day10, only: [hash: 1]

  @grid_size 128

  defmodule Square do
    defstruct [
      used: false,
      visited: false
    ]
  end

  def part1(input) do
    input
    |> construct_grid
    |> Map.values
    |> Enum.count(fn(square) -> square.used end)
  end

  def construct_grid(input) do
    Enum.reduce(0..127, [], fn(row, acc) ->
      [{"#{input}-#{row}", row} | acc]
    end)
    |> Enum.map(fn({inp, row}) -> {hash(inp), row} end)
    |> Enum.reduce(%{}, fn({h, row}, grid) ->
      raw_hash = h
      |> String.to_integer(16)

      Enum.reduce(0..127, %{}, fn(column, column_map) ->
        Map.put(column_map,
                {row, column},
                struct(
                  %Square{},
                  used: ((raw_hash >>> column) &&& 1) == 1
                )
        )
      end)
      |> Map.merge(grid)
    end)
  end

  def part2(input) do
    input
    |> construct_grid
    |> count_regions
  end

  def count_regions(grid) do
    coords = for x <- 0..(@grid_size-1), y <- 0..(@grid_size-1), do: {x, y}
    count_regions(grid, coords, 0)
  end
  def count_regions(_grid, [], count), do: count
  def count_regions(grid, [coord | rest], count) do
    if can_explore(grid, coord) do
      explore_region(grid, coord)
      |> count_regions(rest, count + 1)
    else
      count_regions(grid, rest, count)
    end
  end

  @neighbors [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]
  def explore_region(grid, coord) when not is_list(coord), do: explore_region(grid, [coord])
  def explore_region(grid, []), do: grid
  def explore_region(grid, [{x, y} = coord | rest]) do
    grid = Map.update!(grid, coord, fn(square) -> struct(square, visited: true) end)

    unvisited_neighbors = Enum.map(@neighbors, fn({shiftx, shifty}) -> {x + shiftx, y + shifty} end)
    |> Enum.filter(fn
      ({x, y}) when x < 0 or x >= @grid_size or y < 0 or y >= @grid_size -> false
      (neighbor) -> can_explore(grid, neighbor)
    end)

    explore_region(grid, unvisited_neighbors ++ rest)
  end

  def can_explore(grid, coord) do
    square = grid[coord]
    square.used and not square.visited
  end
end
