defmodule Day13 do

    def part1(input) do
        input
        |> parse_input
        |> run
    end

    @doc """
        iex> Day13.run([{0, 2}])
        0

        iex> Day13.run([{0, 2}, {2, 2}])
        4

        iex> Day13.run([{0, 2}, {1, 2}, {4, 4}, {6, 4}])
        24

        iex> Day13.run([{0, 2}, {1, 2}, {4, 4}, {6, 4}], 4)
        0
    """
    def run(firewall, time_delay \\ 0) do
        firewall
        |> Enum.filter(&caught?(&1, time_delay))
        |> Enum.reduce(0, fn({depth, range}, acc) -> acc + depth * range end)
    end

    def caught?({depth, range}, time_delay) do
      rem(depth + time_delay, (range - 1) * 2) == 0
    end

    def parse_input(input) do
        input
        |> String.trim
        |> String.split("\n")
        |> Enum.map(fn(s) ->
            s
            |> String.split(": ")
            |> Enum.map(&String.to_integer/1)
            |> List.to_tuple
        end)
    end

    def part2(input) do
      input
      |> parse_input
      |> foo(0)
    end

    def sneak(firewall, delay) do
      firewall
      |> Enum.any?(&caught?(&1, delay))
      |> case do
        false -> delay
        true -> sneak(firewall, delay + 1)
      end
    end
end
