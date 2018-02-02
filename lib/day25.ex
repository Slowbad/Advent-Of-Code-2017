defmodule Day25 do
  @steps_to_checksum 12_302_209
  def part1() do
    run(@steps_to_checksum)
    |> Map.values
    |> Enum.sum()
  end

  def part2() do
  end

  def run(steps), do: run(%{}, 0, :A, steps)
  def run(tape, _position, _state, steps) when steps == 0, do: tape
  def run(tape, position, state, steps) do
    val = Map.get(tape, position, 0)
    {new_val, new_position, next_state} = process(state, val, position)
    run(Map.put(tape, position, new_val), new_position, next_state, steps - 1)
  end

  def process(:A, 0, position), do: {1, position + 1, :B}
  def process(:A, 1, position), do: {0, position - 1, :D}

  def process(:B, 0, position), do: {1, position + 1, :C}
  def process(:B, 1, position), do: {0, position + 1, :F}

  def process(:C, 0, position), do: {1, position - 1, :C}
  def process(:C, 1, position), do: {1, position - 1, :A}

  def process(:D, 0, position), do: {0, position - 1, :E}
  def process(:D, 1, position), do: {1, position + 1, :A}

  def process(:E, 0, position), do: {1, position - 1, :A}
  def process(:E, 1, position), do: {0, position + 1, :B}

  def process(:F, 0, position), do: {0, position + 1, :C}
  def process(:F, 1, position), do: {0, position + 1, :E}
end
