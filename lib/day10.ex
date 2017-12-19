defmodule Day10 do
    def part1(input) do
        input
        |> String.trim
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
        |> knot
        |> elem(0)
        |> (fn [first, second | _] -> first * second end).()
    end

    def part2(input) do
      hash(input)
    end

    def hash(input) do
        sequence = input
        |> String.to_charlist
        |> Enum.concat([17, 31, 73, 47, 23])

        Enum.reduce(1..64, {Enum.to_list(0..255), 0, 0}, fn
            (_n, {data, position, skip_size}) -> knot(sequence, data, position, skip_size)
        end)
        |> elem(0)
        |> Enum.chunk(16)
        |> Enum.map(fn ([first | rest]) ->
            use Bitwise, only_operators: true
            Enum.reduce(rest, first, fn(a, acc) -> a ^^^ acc end)
        end)
        |> Enum.map_join(fn (number) ->
            Integer.to_string(number, 16)
            |> String.pad_leading(2, "0")
        end)
        |> String.downcase
    end

    @doc """
        iex> Day10.knot([3,4,1,5], Enum.to_list(0..4))
        {[3, 4, 2, 1, 0], 4, 4}
    """
    def knot(input, data \\ Enum.to_list(0..255), position \\ 0, skip_size \\ 0) do
        input
        |> Enum.reduce({data, position, skip_size}, &twist/2)
    end

    @doc """
        iex> Day10.twist(3, {[0, 1, 2, 3, 4], 0, 0})
        {[2, 1, 0, 3, 4], 3, 1}

        iex> Day10.twist(4, {[2, 1, 0, 3, 4], 3, 1})
        {[4, 3, 0, 1, 2], 3, 2}
    """
    def twist(twist_length, {data, position, skip_size}) do
        data_size = length(data)

        updated_data = data
        |> Enum.split(position)
        |> (fn {left, right} -> right ++ left end).() # Make the position the start of the list to avoid wrapping around the end.
        |> Enum.split(twist_length)
        |> (fn {left, right} -> Enum.reverse(left) ++ right end).() # Twist the section we care about
        |> Enum.split(data_size - position)
        |> (fn {left, right} -> right ++ left end).() # Correct the sequence

        {
            updated_data,
            rem(position + twist_length + skip_size, data_size),
            skip_size + 1
        }
    end

end
