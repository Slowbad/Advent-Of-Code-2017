defmodule Day18 do
  def part1(input) do
    input
    |> parse_instructions()
    |> process()
  end

  @doc """
      iex> Day18.process([{:set, :a, 1}, {:snd, :a}, {:rcv, :a}])
      1

      iex> Day18.process([{:set, :a, 1}, {:set, :i, 2}, {:mul, :a, 2}, {:add, :i , -1}, {:jgz, :i, -2}, {:snd, :a}, {:rcv, :a}])
      4
  """
  def process(instructions) do
    process([], instructions, create_registers(), :none_sent)
  end

  def process(_, [], _), do: raise "Ran out of instructions"
  def process(old, [{:snd, reg} = current | pending], registers, _last_sent) do
    process([current | old], pending, registers, registers[reg])
  end

  def process(old, [{:set, reg, arg} = current | pending], registers, last_sent) when is_atom(arg) do
    registers = registers
                |> Map.put(reg, registers[arg])
    process([current | old], pending, registers, last_sent)
  end
  def process(old, [{:set, reg, arg} = current | pending], registers, last_sent) when is_integer(arg) do
    registers = registers
                |> Map.put(reg, arg)
    process([current | old], pending, registers, last_sent)
  end

  def process(old, [{:mul, reg, arg} = current | pending], registers, last_sent) when is_atom(arg) do
    registers = registers
                |> Map.put(reg, registers[reg] * registers[arg])
    process([current | old], pending, registers, last_sent)
 end
  def process(old, [{:mul, reg, arg} = current | pending], registers, last_sent) when is_integer(arg) do
    registers = registers
                |> Map.put(reg, registers[reg] * arg)
    process([current | old], pending, registers, last_sent)
  end

  def process(old, [{:add, reg, arg} = current | pending], registers, last_sent) when is_atom(arg) do
    registers = registers
                |> Map.put(reg, registers[reg] + registers[arg])
    process([current | old], pending, registers, last_sent)
  end
  def process(old, [{:add, reg, arg} = current | pending], registers, last_sent) when is_integer(arg) do
    registers = registers
                |> Map.put(reg, registers[reg] + arg)
    process([current | old], pending, registers, last_sent)
  end

  def process(old, [{:mod, reg, arg} = current | pending], registers, last_sent) when is_atom(arg) do
    registers = registers
                |> Map.put(reg, rem(registers[reg], registers[arg]))
    process([current | old], pending, registers, last_sent)
  end
  def process(old, [{:mod, reg, arg} = current | pending], registers, last_sent) when is_integer(arg) do
    registers = registers
                |> Map.put(reg, rem(registers[reg], arg))
    process([current | old], pending, registers, last_sent)
  end

  def process(old, [{:jgz, reg, arg} = current | pending], registers, last_sent) when is_atom(arg) do
    if registers[reg] > 0 do
      {updated_old, updated_pending} = jump(old, current, pending, registers[arg])
      process(updated_old, updated_pending, registers, last_sent)
    else
      process([current | old], pending, registers, last_sent)
    end
  end
  def process(old, [{:jgz, reg, arg} = current | pending], registers, last_sent) when is_integer(arg) do
    if registers[reg] > 0 do
      {updated_old, updated_pending} = jump(old, current, pending, arg)
      process(updated_old, updated_pending, registers, last_sent)
    else
      process([current | old], pending, registers, last_sent)
    end
  end

  def process(old, [{:rcv, reg} = current | pending], registers, last_sent) do
    if registers[reg] != 0 do
      last_sent
    else
      process([current | old], pending, registers, last_sent)
    end
  end

  def part2(_input) do
  end

  @doc """
      iex> Day18.jump([1], 2, [3], 0)
      {[1], [2, 3]}

      iex> Day18.jump([1], 2, [3], 1)
      {[2, 1], [3]}

      iex> Day18.jump([1], 2, [3], -1)
      {[], [1, 2, 3]}

      iex> Day18.jump([3, 2, 1], 4, [5], -2)
      {[1], [2, 3, 4, 5]}
  """
  def jump(old, current, pending, 0), do: {old, [current | pending]}
  def jump(old, current, [new_current | pending], jump_position) when jump_position > 0 do
    jump([current | old], new_current, pending, jump_position - 1)
  end
  def jump([new_current | old], current, pending, jump_position) when jump_position < 0 do
    jump(old, new_current, [current | pending], jump_position + 1)
  end

  @doc """
      iex> Day18.parse_instructions("snd a\\nmul b c\\nadd a 1")
      [{:snd, :a}, {:mul, :b, :c}, {:add, :a, 1}]
  """
  def parse_instructions(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn(line) ->
      case line |> String.split() do
        [inst, reg] ->
          {String.to_atom(inst), String.to_atom(reg)}
        [inst, reg, arg] ->
          {
            String.to_atom(inst),
            String.to_atom(reg),
            case Integer.parse(arg) do
              {val, _} -> val
              _ -> String.to_atom(arg)
            end
          }
      end
    end)
  end

  def create_registers() do
    Enum.reduce(?a..?z, %{}, fn(cp, acc) ->
      acc
      |> Map.put([cp] |> List.to_string() |> String.to_atom(), 0)
    end)
  end
end
