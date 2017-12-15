defmodule Day13 do
    defmodule Scanner do
        defstruct [
            depth: 0,
            range: 0,
            position: 0,
            direction: :up
        ]
    end

    def part1(input) do
        input
        |> parse_input
        |> run
    end

    @doc """
        iex> Day13.run([%Day13.Scanner{range: 2}])
        0

        iex> Day13.run([%Day13.Scanner{range: 2}, nil, %Day13.Scanner{depth: 2, range: 2}])
        4
    """
    def run([_scanner | remaining]), do: run(remaining, 0)
    def run([], severity), do: severity
    def run([scanner | remaining], severity) when is_nil(scanner), do: run(remaining, severity)
    def run([scanner | remaining], severity) do
        scanner = Enum.reduce(1..scanner.depth, scanner, fn(_, scn) -> step(scn) end)
        severity =
            case scanner.position do
                0 -> severity + scanner.depth * scanner.range
                _ -> severity
            end

        run(remaining, severity)
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
        |> Enum.into(%{})
        |> to_firewall
    end

    def to_firewall(input) do
        firewall_depth = input |> Map.keys |> Enum.max
        Enum.reduce(0..firewall_depth, [], fn(n, acc) ->
            result =
                case input[n] do
                    nil -> nil
                    range -> %Scanner{depth: n, range: range}
                end
            [result | acc]
        end)
        |> Enum.reverse
    end

    def step(%Scanner{range: range, position: position, direction: :up} = scanner) when position == range - 1, do: struct(scanner, position: position - 1, direction: :down)
    def step(%Scanner{position: position, direction: :down} = scanner) when position == 0, do: struct(scanner, position: position + 1, direction: :up)
    def step(%Scanner{position: position, direction: :up} = scanner), do: struct(scanner, position: position + 1)
    def step(%Scanner{position: position, direction: :down} = scanner), do: struct(scanner, position: position - 1)

    def part2(_input) do

    end
end