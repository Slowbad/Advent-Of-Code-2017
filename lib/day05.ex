defmodule AdventOfCode2017.Day05 do
    defmodule State do
        defstruct [
            position: 0,
            step_count: 0,
            jump_count: 0,
            jumps: %{}
        ]
    end


    def part1(input) do
        final_state = input
        |> parse_input
        |> Stream.iterate(&traverse1/1)
        |> Enum.find(fn(%State{position: position, jump_count: jump_count}) ->
            position < 0 or position >= jump_count
        end)

        final_state.step_count
    end

    def part2(input) do
        final_state = input
        |> parse_input
        |> Stream.iterate(&traverse2/1)
        |> Enum.find(fn(%State{position: position, jump_count: jump_count}) ->
            position < 0 or position >= jump_count
        end)

        final_state.step_count
    end

    def parse_input(input) do
        jumps = input
        |> String.trim
        |> String.split(["\n", "\r\n"])
        |> Enum.map(&String.to_integer/1)
        |> to_numbered_map

        %State{jumps: jumps, jump_count: Enum.count(jumps)}
    end

    def to_numbered_map(jumps) do
        to_numbered_map(0, jumps)
    end
    def to_numbered_map(_, []), do: %{}
    def to_numbered_map(count, [head | tail]) do
        Map.put(to_numbered_map(count + 1, tail), count, head)
    end

    def traverse1(%State{} = state), do: traverse(state, fn(offset) -> offset + 1 end)
    def traverse2(%State{} = state) do 
        traverse(state, fn
            (offset) when offset >= 3 -> offset - 1
            (offset) -> offset + 1
        end)
    end

    def traverse(%State{position: position, step_count: step_count, jumps: jumps} = state, increment) do
        struct(state, 
            position: position + jumps[position], 
            step_count: step_count + 1, 
            jumps: Map.update!(jumps, position, increment))
    end
end