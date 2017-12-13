defmodule Day09 do
    def part1(input) do
        input
        |> String.graphemes
        |> group_score
    end

    def part2(input) do
        input
        |> String.graphemes
        |> garbage_score
    end

    @doc """
        iex> "{}" |> String.graphemes |> Day09.group_score
        1

        iex> "{{{}}}" |> String.graphemes |> Day09.group_score
        6

        iex> "{{},{}}" |> String.graphemes |> Day09.group_score
        5

        iex> "{{{},{},{{}}}}" |> String.graphemes |> Day09.group_score
        16

        iex> "{<a>,<a>,<a>,<a>}" |> String.graphemes |> Day09.group_score
        1

        iex> "{{<ab>},{<ab>},{<ab>},{<ab>}}" |> String.graphemes |> Day09.group_score
        9

        iex> "{{<ab>},{<ab>},{<ab>},{<ab>}}" |> String.graphemes |> Day09.group_score
        9

        iex> "{{<!!>},{<!!>},{<!!>},{<!!>}}" |> String.graphemes |> Day09.group_score
        9

        iex> "{{<a!>},{<a!>},{<a!>},{<ab>}}" |> String.graphemes |> Day09.group_score
        3
    """
    def group_score(stream), do: group_score(stream, 0)
    def group_score([], _gcount), do: 0
    def group_score(["{" | rest], gcount), do: group_score(rest, gcount + 1)
    def group_score(["}" | rest], gcount), do: gcount + group_score(rest, gcount - 1)
    def group_score(["<" | rest], gcount), do: group_score_garbage(rest) |> group_score(gcount)
    def group_score([_ | rest], gcount), do: group_score(rest, gcount)

    def group_score_garbage(["!", _ | rest]), do: group_score_garbage(rest)
    def group_score_garbage([">" | rest]), do: rest
    def group_score_garbage([_ | rest]), do: group_score_garbage(rest)

    @doc """
        iex> "{<>}" |> String.graphemes |> Day09.garbage_score()
        0

        iex> "{<hjkl;>}" |> String.graphemes |> Day09.garbage_score()
        5

        iex> "{<<<<>}" |> String.graphemes |> Day09.garbage_score()
        3

        iex> "{<{!>}fh>}" |> String.graphemes |> Day09.garbage_score()
        4

        iex> "{<!!>}" |> String.graphemes |> Day09.garbage_score()
        0

        iex> "{<!!!>>}" |> String.graphemes |> Day09.garbage_score()
        0

        iex> "{<{o\\"i!a,<{i<a>}" |> String.graphemes |> Day09.garbage_score()
        10
    """
    def garbage_score([]), do: 0
    def garbage_score(["<" | rest]) do
        {score, remaining_stream} = garbage_score_counter(rest, 0)
        score + garbage_score(remaining_stream)
    end
    def garbage_score([_ | rest]), do: garbage_score(rest)

    def garbage_score_counter(["!", _ | rest], score), do: garbage_score_counter(rest, score)
    def garbage_score_counter([">" | rest], score), do: {score, rest}
    def garbage_score_counter([_ | rest], score), do: garbage_score_counter(rest, score + 1)

end