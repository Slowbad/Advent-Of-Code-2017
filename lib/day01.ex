defmodule AdventOfCode2017.Day01 do
    def check_digits(first, second) when is_binary(first) and is_binary(second) do
        {fint, _} = Integer.parse(first)
        {sint, _} = Integer.parse(second)
        check_digits(fint, sint)
    end

    def check_digits(first, second) do
        cond do
            first == second -> first
            true -> 0
        end
    end

    def basic([_ | []]), do: 0
    def basic([first | [ second | rest ]]) do
        check_digits(first, second) + basic([second | rest])
    end

    def half_skip(all) do
        shifted = shift_list(all)
        half_skip(all, shifted)
    end

    def half_skip([], []), do: 0
    def half_skip([head_orig | rest_orig], [head_shifted | rest_shifted]) do
        check_digits(head_orig, head_shifted) + half_skip(rest_orig, rest_shifted)
    end

    def shift_list(list), do: shift_list(list, [])

    def shift_list(orig, other) when length(orig) == length(other), do: orig ++ Enum.reverse(other)

    def shift_list([head | tail], other), do: shift_list(tail, [head | other])

end