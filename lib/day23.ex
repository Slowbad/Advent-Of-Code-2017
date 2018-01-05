defmodule Day23 do
  def part1(input) do
    input
    |> parse_input
    |> process(0, construct_registers(), 0)
    |> elem(0)
  end

  @doc """
  After rewriting the program as normal C style statements I realized it was looking for
  non-primes but wasn't exiting when it flipped the flag register, f. Here I just come up
  with the answer instead of messing with the instruction set.

  To optimize the assembly-esque instructions, we could replace setting f to 0 to a jump
  instruction to the place where we add 1 to h. After that we could change the inner loop
  so that e starts at b then subtracts d until we get to less than 0. This would cut out
  another significant portion of the repetitions.
  """
  def part2() do
    non_primes_between(106_700, 123_700, 17)
  end

  @doc """
      iex> Day23.non_primes_between(4, 4, 3)
      1
  """
  def non_primes_between(b, c, interval, count \\ 0)
  def non_primes_between(b, c, _interval, count) when b > c do
    count
  end
  def non_primes_between(b, c, interval, count) do
    non_primes_between(b + interval, c, interval, count + if(is_not_prime?(b), do: 1, else: 0))
  end

  @doc """
      iex> Day23.is_not_prime?(4)
      true

      iex> Day23.is_not_prime?(11)
      false

      iex> Day23.is_not_prime?(16)
      true
  """
  def is_not_prime?(n) do
    2..div(n, 2)
    |> Enum.any?(fn(m) -> rem(n, m) == 0 end)
  end

#  @doc """
#      iex> Day23.process(%{0 => {:mul, :a, 5}}, 0, %{a: 0}, 0)
#      1
#  """
  def process(instructions, position, registers, count)
    when position < 0 or position >= map_size(instructions) do
      {count, registers[:h]}
  end
  def process(instructions, position, registers, count) do
    instr = instructions[position]
    cmd = instr |> elem(0)

    registers = case cmd do
      :set -> set(instr, registers)
      :sub -> sub(instr, registers)
      :mul -> mul(instr, registers)
      _ -> registers
    end

    position = case cmd do
      :jnz -> position + jnz(instr, registers)
      _ -> position + 1
    end

    count = if cmd == :mul, do: count + 1, else: count

    process(instructions, position, registers, count)
  end

  @doc """
      iex> Day23.set({:set, :a, :b}, %{a: 0, b: 5})
      %{a: 5, b: 5}

      iex> Day23.set({:set, :a, 5}, %{a: 0})
      %{a: 5}
  """
  def set({:set, regX, regY}, registers) when is_atom(regY) do
    set({:set, regX, registers[regY]}, registers)
  end
  def set({:set, regX, val}, registers) when is_integer(val) do
    Map.put(registers, regX, val)
  end

  @doc """
      iex> Day23.sub({:sub, :a, :b}, %{a: 7, b: 5})
      %{a: 2, b: 5}

      iex> Day23.sub({:sub, :a, 5}, %{a: 13})
      %{a: 8}
  """
  def sub({:sub, regX, regY}, registers) when is_atom(regY) do
    sub({:sub, regX, registers[regY]}, registers)
  end
  def sub({:sub, regX, val}, registers) when is_integer(val) do
    Map.put(registers, regX, registers[regX] - val)
  end

  @doc """
      iex> Day23.mul({:mul, :a, :b}, %{a: 2, b: 3})
      %{a: 6, b: 3}

      iex> Day23.mul({:mul, :a, 9}, %{a: 3})
      %{a: 27}
  """
  def mul({:mul, regX, regY}, registers) when is_atom(regY) do
    mul({:mul, regX, registers[regY]}, registers)
  end
  def mul({:mul, regX, val}, registers) when is_integer(val) do
    Map.put(registers, regX, registers[regX] * val)
  end

  @doc """
  Just calculates the offset to apply the current position in the instructions

      iex> Day23.jnz({:jnz, :a, :b}, %{a: 2, b: 3})
      3

      iex> Day23.jnz({:jnz, :a, 9}, %{a: 3})
      9

      iex> Day23.jnz({:jnz, :a, :b}, %{a: 0, b: 4})
      1

      iex> Day23.jnz({:jnz, :a, 16}, %{a: 0})
      1
  """
  def jnz({:jnz, argX, argY}, _registers) when is_integer(argX) and is_integer(argY) do
    if not(argX == 0) do
      argY
    else
      1
    end
  end
  def jnz({:jnz, argX, argY}, registers) do
    jnz({:jnz,
      if(is_atom(argX), do: registers[argX], else: argX),
      if(is_atom(argY), do: registers[argY], else: argY)},
      registers)
  end

  def construct_registers(debug \\ false) do
    Enum.reduce(?a..?h, %{}, fn(letter, acc) ->
      Map.put(acc, <<letter>> |> String.to_atom, 0)
    end)
    |> Map.put(:a, if(debug, do: 1, else: 0))
  end

  def parse_input(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn(line) ->
      [cmd, p1, p2] = line |> String.split(" ")
      {cmd |> String.to_atom, p1 |> int_or_atom, p2 |> int_or_atom}
    end)
    |> Enum.with_index
    |> Enum.map(fn({k, v}) -> {v, k} end)
    |> Enum.into(%{})
  end

  def int_or_atom(str) do
    case Integer.parse(str) do
      {val, _} -> val
      :error -> String.to_atom(str)
    end
  end
end
