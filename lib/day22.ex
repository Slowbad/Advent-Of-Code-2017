defmodule Day22 do
  def part1(input, iterations \\ 10000) do
    grid = input |> parse_input

    Stream.iterate({grid, {0, 0}, :up, 0}, fn
      ({g, n, d, c}) ->
        {g, n, d, infected?} = burst(g, n, d)
        #{g, n |> IO.inspect(label: "node"), d |> IO.inspect(label: "direction"), c + if(infected? |> IO.inspect(label: "infected?"), do: 1, else: 0)}
        {g, n, d, c + if(infected?, do: 1, else: 0)}
    end)
    |> Enum.at(iterations)
    |> elem(3)
  end

  def part2(_) do
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
      iex> Day22.burst(%{{0, 0} => :infected}, {0, 0}, :up)
      {%{{0, 0} => :clean}, {1, 0}, :right, false}

      iex> Day22.burst(%{{0, 0} => :clean}, {0, 0}, :up)
      {%{{0, 0} => :infected}, {-1, 0}, :left, true}
  """
  def burst(grid, current_node, direction) do
    new_direction = turn(grid, current_node, direction)
    {updated_grid, node_infected} = scramble(grid, current_node)
    next_node = move(current_node, new_direction)
    {updated_grid, next_node, new_direction, node_infected}
  end

  def turn(grid, node, direction) do
    case Map.get(grid, node, :clean) do
      :infected -> right(direction)
      :clean -> left(direction)
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

  def scramble(grid, node) do
    flipped_state = case Map.get(grid, node, :clean) do
      :clean -> :infected
      :infected -> :clean
    end
    {Map.put(grid, node, flipped_state), flipped_state == :infected}
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
