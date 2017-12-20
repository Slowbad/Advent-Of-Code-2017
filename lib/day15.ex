defmodule Day15 do
  use Bitwise

  @prime 2147483647

  def gen_a(val), do: rem(val * 16807, @prime)
  def gen_a(val, mult) do
    new = gen_a(val)
    case rem(new, mult) do
      0 -> new
      _ -> gen_a(new, mult)
    end
  end
  def gen_b(val), do: rem(val * 48271, @prime)
  def gen_b(val, mult) do
    new = gen_b(val)
    case rem(new, mult) do
      0 -> new
      _ -> gen_b(new, mult)
    end
  end

  def part1(input) do
    [starta, startb] = input
                       |> parse_input

    Enum.reduce(1..40_000_000, {starta, startb, judge(starta, startb)}, fn
      (_, {vala, valb, score}) ->
        newa = gen_a vala
        newb = gen_b valb
        {newa, newb, judge(newa, newb) + score}
    end)
    |> elem(2)
  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn(line) ->
      line
      |> String.split
      |> List.last
      |> String.to_integer
    end)
  end

  @doc """
      iex> Day15.judge(245556042, 1431495498)
      1

      iex> Day15.judge(1092455, 430625591)
      0
  """
  def judge(vala, valb) do
    case foo(vala) == foo(valb) do
      true -> 1
      false -> 0
    end
  end

  def foo(val), do: val &&& 65535

  def part2(input) do
    [starta, startb] = input
                       |> parse_input

    Enum.reduce(1..5_000_000, {starta, startb, judge(starta, startb)}, fn
      (_, {vala, valb, score}) ->
        newa = gen_a vala, 4
        newb = gen_b valb, 8
        {newa, newb, judge(newa, newb) + score}
    end)
    |> elem(2)
  end
end
