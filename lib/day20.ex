defmodule Day20 do
  @doc """
      iex> Day20.part1("p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>\\np=< 4,0,0>, v=< 0,0,0>, a=<-2,0,0>")
      0
  """
  def part1(input) do
    vectors = input
    |> parse_input

    winner = vectors
    |> Enum.min_by(fn({_, _, acceleration}) -> manhattan_distance(acceleration) end)

    vectors
    |> Enum.find_index(fn(vector) -> vector == winner end)
  end

  # Assuming that all collisions will occur in the first 1000 steps of the simulation
  @doc """
      iex> Day20.part2("p=<-7,0,0>, v=< 2,0,0>, a=< 1,0,0>\\np=<-4,0,0>, v=< 2,0,0>, a=< 0,0,0>\\np=<-2,0,0>, v=< 1,0,0>, a=< 0,0,0>\\np=< 3,0,0>, v=<-1,0,0>, a=< 0,0,0>")
      1
  """
  def part2(input) do
    vectors = input |> parse_input

    run(vectors, 1000)
    |> Enum.count
  end

  def run(vectors, 0), do: vectors
  def run(vectors, iter) do
    vectors
    |> purge_collisions
    |> Enum.map(&update/1)
    |> run(iter - 1)
  end

  @doc """
      iex> Day20.purge_collisions([{{1, 2, 3}, {1, 2, 3}, {1, 2, 3}}, {{1, 2, 3}, {1, 2, 3}, {1, 2, 3}}])
      []
  """
  def purge_collisions(vectors) do
    is_unique = vectors
                |> Enum.reduce(%{}, fn({p, _, _}, acc) ->
                  case acc[p] do
                    nil -> Map.put(acc, p, false)
                    false -> Map.put(acc, p, true)
                    true -> acc
                  end
                end)

    vectors
    |> Enum.reject(fn({p, _, _}) -> is_unique[p] end)
  end

  @doc """
      iex> Day20.update({{0, 0, 0}, {0, 0, 0}, {1, 2, 3}})
      {{1, 2, 3}, {1, 2, 3}, {1, 2, 3}}
  """
  def update({position, velocity, acceleration}) do
    new_vel = add_part(velocity, acceleration)
    new_pos = add_part(position, new_vel)
    {new_pos, new_vel, acceleration}
  end

  def add_part({x1, y1, z1}, {x2, y2, z2}) do
    {x1 + x2, y1 + y2, z1 + z2}
  end

  # Assumes distance to 0, 0, 0
  def manhattan_distance({x, y, z}) do
    abs(x) + abs(y) + abs(z)
  end

  def parse_input(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&line/1)
  end

  @doc """
      iex> Day20.line("p=<1,2,3>, v=<-1,-2,-3>, a=<0,0,0>")
      {{1, 2, 3}, {-1, -2, -3}, {0, 0, 0}}
  """
  def line(l) do
    l
    |> String.split(", ")
    |> Enum.map(fn(vector) ->
      Regex.scan(~r/-?\d+/, vector)
      |> List.flatten
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple
    end)
    |> List.to_tuple
  end
end
