defmodule Day17 do
  def part1(spin_size) do
    {buffer, position} = spinlock(2017, spin_size)

    Enum.at(buffer, position + 1)
  end

  # Only keep track of the value next to zero. The rest of buffer doesn't matter.
  def part2(spin_size) do
    Enum.reduce(1..50_000_000, {0, nil}, fn(val, {position, beside_zero}) ->
      next_position = rem(position + spin_size, val) + 1
      beside_zero = if next_position == 1, do: val, else: beside_zero
      {next_position, beside_zero}
    end)
    |> elem(1)
  end

  # naive implementation
  def spinlock(iterations, spin_size) do
    Enum.reduce(1..iterations, {[0], 0}, fn(n, {buffer, position}) ->
      insert(buffer, position, n, spin_size)
    end)
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
    {List.insert_at(buffer, new_position, next_value), new_position}
  end
end