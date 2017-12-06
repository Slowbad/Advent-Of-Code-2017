defmodule AdventOfCode2017.Day06 do
    # @doc """
    #     iex> AdventOfCode2017.Day06.part1("0\t2\t7\t0")
    #     5
    # """
    def part1(input) do
        input
        |> parse_input
        |> count_to_dupe
    end

    def parse_input(input) do
        input
        |> String.trim
        |> String.split("\t")
        |> Enum.map(&String.to_integer/1)
        |> Enum.reduce(%{count: 0}, fn(i, acc) ->
            Map.put(acc, acc.count, i)
            |> Map.put(:count, acc.count + 1)
        end)
        |> Map.delete(:count)
    end

    def count_to_dupe(state) do
        count_to_dupe(state, [], Enum.count(state), 1)
    end
    def count_to_dupe(state, history, state_size, count) do
        max_pos = find_max(state)
        block_size = state[max_pos]

        new_state = Map.put(state, max_pos, 0)
        |> redistribute(next_pos(max_pos, state_size) , state_size, block_size)
        
        cond do
            contains(history, new_state) -> count
            true -> count_to_dupe(new_state, [new_state | history], state_size, count + 1)
        end
    end

    # @doc """
    #     iex> AdventOfCode2017.Day06.redistribute(%{0 => 0, 1 => 1}, 1, 2, 1)
    #     %{0 => 0, 1 => 2}

    #     iex> AdventOfCode2017.Day06.redistribute(%{0 => 0, 1 => 2, 2 => 0, 3 => 0}, 3, 4, 7)
    #     %{0 => 2, 1 => 4, 2 => 1, 3 => 2}
    # """
    def redistribute(state, _position, _state_size, remaining) when remaining == 0 do
        state
    end
    def redistribute(state, position, state_size, remaining) do
        Map.update!(state, position, fn(v) -> v + 1 end)
        |> redistribute(next_pos(position, state_size), state_size, remaining - 1)
    end

    def next_pos(position, max) when position == max - 1, do: 0
    def next_pos(position, max), do: position + 1

    def contains(history, state) do
        Enum.any?(history, fn(s) -> s == state end)
    end
    @doc """
        iex> AdventOfCode2017.Day06.find_max(%{0 => 1, 1 => 2, 2 => 0})
        1

        iex> AdventOfCode2017.Day06.find_max(%{0 => 5, 1 => 4, 2 => 5})
        0
    """
    def find_max(state), do: find_max(state, Enum.count(state), 0, {-1, -1})
    def find_max(_state, size, current, {position, _max}) when size == current, do: position
    def find_max(state, size, current, {_position, max} = current_max) do
        new_max = cond do
            max < state[current] -> {current, state[current]}
            true -> current_max
        end
        find_max(state, size, current + 1, new_max)
    end
end
