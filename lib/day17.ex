defmodule Day17 do
  def part1(spin_size) do
    {buffer, position} = Enum.reduce(1..2017, {[0], 0}, fn(n, {buffer, position}) ->
      insert(buffer, position, n, spin_size)
    end)

    Enum.at(buffer, position + 1)
  end

  def part2(_input) do
  end

  @doc """
      iex> Day17.insert([0], 0, 1, 3)
      {[0, 1], 1}

      iex> Day17.insert([0, 1], 1, 2, 3)
      {[0, 2, 1], 1}

      iex> Day17.insert([0, 2, 1], 1, 3, 3)
      {[0, 2, 3, 1], 2}
  """
  def insert(buffer, position, next_value, spin_size) do
    new_position = rem(position + spin_size, length(buffer)) + 1
    {front, back} = Enum.split(buffer, new_position)
    {front ++ [next_value] ++ back, new_position}
  end
end