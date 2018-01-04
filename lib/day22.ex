defmodule Day22 do
  def part1(input, iterations \\ 10_000) do
    grid = input |> parse_input

    Stream.iterate({grid, {0, 0}, :up, 0}, fn
      ({g, n, d, c}) ->
        {g, n, d, infected?} = burst(g, n, d, false)
        {g, n, d, c + if(infected?, do: 1, else: 0)}
    end)
    |> Enum.at(iterations)
    |> elem(3)
  end

  def part2(input, iterations \\ 10_000_000) do
    grid = input |> parse_input

    Stream.iterate({grid, {0, 0}, :up, 0}, fn
      ({g, n, d, c}) ->
        {g, n, d, infected?} = burst(g, n, d, true)
        {g, n, d, c + if(infected?, do: 1, else: 0)}
    end)
    |> Enum.at(iterations)
    |> elem(3)
  end

  def parse_input(input) do
    lines = input
    |> String.trim
    |> String.split("\n")

    grid_width = lines |> hd |> String.length |> div(2)

    lines
    |> Enum.reduce({%{}, grid_width}, fn
      (line, {grid, y}) ->
        grid = line
        |> String.split("", trim: true)
        |> Enum.reduce({%{}, -grid_width}, fn
          (val, {sub_grid, x}) ->
            state = case val do
              "#" -> :infected
              "." -> :clean
            end
            {Map.put(sub_grid, {x, y}, state), x + 1}
        end)
        |> elem(0)
        |> Map.merge(grid)

        {grid, y - 1}
    end)
    |> elem(0)
  end

  @doc """
      iex> Day22.burst(%{{0, 0} => :infected}, {0, 0}, :up, false)
      {%{{0, 0} => :clean}, {1, 0}, :right, false}

      iex> Day22.burst(%{{0, 0} => :clean}, {0, 0}, :up, false)
      {%{{0, 0} => :infected}, {-1, 0}, :left, true}
  """
  def burst(grid, current_node, direction, advanced?) do
    new_direction = turn(grid, current_node, direction)
    {updated_grid, node_infected} = scramble(grid, current_node, advanced?)
    next_node = move(current_node, new_direction)
    {updated_grid, next_node, new_direction, node_infected}
  end

  def turn(grid, node, direction) do
    case Map.get(grid, node, :clean) do
      :infected -> right(direction)
      :clean -> left(direction)
      :weakened -> direction
      :flagged -> reverse(direction)
    end
  end

  def right(:up), do: :right
  def right(:right), do: :down
  def right(:down), do: :left
  def right(:left), do: :up

  def left(:up), do: :left
  def left(:right), do: :up
  def left(:down), do: :right
  def left(:left), do: :down

  def reverse(:up), do: :down
  def reverse(:down), do: :up
  def reverse(:right), do: :left
  def reverse(:left), do: :right

  def scramble(grid, node, advanced?) do
    flipped_state = next_state(grid, node, advanced?)
    {Map.put(grid, node, flipped_state), flipped_state == :infected}
  end

  def next_state(grid, node, advanced?) when not advanced? do
    case Map.get(grid, node, :clean) do
      :clean -> :infected
      :infected -> :clean
    end
  end

  def next_state(grid, node, advanced?) when advanced? do
    case Map.get(grid, node, :clean) do
      :clean -> :weakened
      :weakened -> :infected
      :infected -> :flagged
      :flagged -> :clean
    end
  end

  def move({x, y}, direction) do
    case direction do
      :up -> {x, y + 1}
      :down -> {x, y - 1}
      :right -> {x + 1, y}
      :left -> {x - 1, y}
    end
  end
end
