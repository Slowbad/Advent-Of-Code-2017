defmodule Day16 do
  def part1(input) do
    input
    |> parse_input
    |> Enum.reduce(initialize_dancers(), &move/2)
    |> Map.values
    |> Enum.map(&Atom.to_string/1)
    |> Enum.join
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

  def part2(_input) do
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

  def initialize_dancers() do
    [:a, :b, :c, :d, :e, :f, :g, :h, :i, :j, :k, :l, :m, :n, :o, :p]
    |> Enum.with_index()
    |> Enum.map(fn({l, i}) -> {i, l} end)
    |> Enum.into(%{})
  end
end
