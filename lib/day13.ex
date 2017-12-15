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

        # iex> Day13.run([{0, 2}, {1, 2}, {4, 4}, {6, 4}], 4)
        # 2
    """
    def run(firewall, time_delay \\ 0) do
        firewall
        |> Enum.filter(fn({depth, range}) -> rem(depth + time_delay, range * 2 - 2) == 0 end)
        |> Enum.reduce(0, fn({depth, range}, acc) -> acc + depth * range end)
    end
    
    def parse_input(input) do
        input
        |> String.trim
        |> String.split("\n")
        |> Enum.map(fn(s) -> 
            [depth, range] = s
            |> String.split(": ")
            |> Enum.map(&String.to_integer/1)
            {depth, range}
        end)
    end

    # def step(%Scanner{range: range, position: position, direction: :up} = scanner) when position == range - 1, do: struct(scanner, position: position - 1, direction: :down)
    # def step(%Scanner{position: position, direction: :down} = scanner) when position == 0, do: struct(scanner, position: position + 1, direction: :up)
    # def step(%Scanner{position: position, direction: :up} = scanner), do: struct(scanner, position: position + 1)
    # def step(%Scanner{position: position, direction: :down} = scanner), do: struct(scanner, position: position - 1)

    def part2(input) do
        firewall = input
        |> parse_input

        {firewall, -1, -1}
        |> Stream.iterate(fn({firewall, time_delay, _}) ->
            time_delay = time_delay + 1
            {firewall, time_delay, run(firewall, time_delay)}
        end)
        |> Enum.take(12)
        # |> Enum.find(fn({_, _, severity}) -> severity == 0 end)
        # |> elem(1)
    end
end