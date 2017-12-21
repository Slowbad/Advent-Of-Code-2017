defmodule Day16 do
  @initial_order %{0 => :a, 1 => :b, 2 => :c, 3 => :d, 4 => :e, 5 => :f, 6 => :g, 7 => :h, 8 => :i, 9 => :j, 10 => :k, 11 => :l, 12 => :m, 13 => :n, 14 => :o, 15 => :p}
  def part1(input) do
    moves = input
    |> parse_input

    @initial_order
    |> dance_round(moves)
    |> dancers_to_string
  end

  def part2(input) do
    moves = input |> parse_input
    cycle_size = find_cycle(@initial_order, moves)
    cycle_size = rem(1_000_000_000, cycle_size)

    dance(@initial_order, moves, cycle_size, 0)
    |> dancers_to_string
  end

  def dance(dancers, _moves, n, acc) when n == acc, do: dancers
  def dance(dancers, moves, n, acc) do
    dance_round(dancers, moves) |> dance(moves, n, acc + 1)
  end

  def find_cycle(dancers, moves, cycle_size \\ 1) do
    case dance_round(dancers, moves) do
      @initial_order -> cycle_size
      new_order -> find_cycle(new_order, moves, cycle_size + 1)
    end
  end

  def dancers_to_string(dancers) do
    dancers
    |> Map.values
    |> Enum.map(&Atom.to_string/1)
    |> Enum.join
  end

  def dance_round(dancers, moves) do
    Enum.reduce(moves, dancers, &move/2)
  end

  @doc """
      iex> Day16.move({:spin, 3}, %{0 => :a, 1 => :b, 2 => :c, 3 => :d, 4 => :e})
      %{0 => :c, 1 => :d, 2 => :e, 3 => :a, 4 => :b}

      iex> Day16.move({:exchange, 3, 4}, %{0 => :a, 1 => :b, 2 => :c, 3 => :d, 4 => :e})
      %{0 => :a, 1 => :b, 2 => :c, 3 => :e, 4 => :d}

      iex> Day16.move({:partner, :a, :c}, %{0 => :a, 1 => :b, 2 => :c, 3 => :d, 4 => :e})
      %{0 => :c, 1 => :b, 2 => :a, 3 => :d, 4 => :e}
  """
  def move({:spin, distance}, dancers) do
    size = map_size(dancers)
    dancers
    |> Enum.map(fn({k, v}) -> {rem(k + distance, size), v} end)
    |> Enum.into(%{})
  end
  def move({:exchange, one, two}, dancers) do
    swap(dancers, one, two)
  end
  def move({:partner, one, two}, dancers) do
    {one_pos, _} = Enum.find(dancers, fn({_, v}) -> v == one end)
    {two_pos, _} = Enum.find(dancers, fn({_, v}) -> v == two end)
    swap(dancers, one_pos, two_pos)
  end

  def swap(dancers, one, two) do
    one_val = dancers[one]
    dancers
    |> Map.put(one, dancers[two])
    |> Map.put(two, one_val)
  end

  @doc """
      iex> Day16.parse_input("s4,x9/15,pj/c")
      [{:spin, 4}, {:exchange, 9, 15}, {:partner, :j, :c}]
  """
  def parse_input(input) do
    input
    |> String.split(",")
    |> Enum.map(fn
      ("s" <> distance) -> {:spin, String.to_integer(distance)}
      ("x" <> rest) ->
        [first, second] = rest
                          |> String.split("/")
                          |> Enum.map(&String.to_integer/1)
        {:exchange, first, second}
      ("p" <> rest) ->
        [first, second] = rest
                          |> String.split("/")
                          |> Enum.map(&String.to_atom/1)
        {:partner, first, second}
    end)
  end
end
