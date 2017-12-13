defmodule Day09 do
    def part1(input) do
        input
        |> String.graphemes
        |> parser
    end

    def part2(_input) do
    end

    @doc """
        iex> "{}" |> String.graphemes |> Day09.parser
        1

        iex> "{{{}}}" |> String.graphemes |> Day09.parser
        6

        iex> "{{},{}}" |> String.graphemes |> Day09.parser
        5

        iex> "{{{},{},{{}}}}" |> String.graphemes |> Day09.parser
        16

        iex> "{<a>,<a>,<a>,<a>}" |> String.graphemes |> Day09.parser
        1

        iex> "{{<ab>},{<ab>},{<ab>},{<ab>}}" |> String.graphemes |> Day09.parser
        9

        iex> "{{<ab>},{<ab>},{<ab>},{<ab>}}" |> String.graphemes |> Day09.parser
        9

        iex> "{{<!!>},{<!!>},{<!!>},{<!!>}}" |> String.graphemes |> Day09.parser
        9

        iex> "{{<a!>},{<a!>},{<a!>},{<ab>}}" |> String.graphemes |> Day09.parser
        3
    """
    def parser(stream), do: parser(stream, 0)
    def parser([], _gcount), do: 0
    def parser(["{" | rest], gcount), do: parser(rest, gcount + 1)
    def parser(["}" | rest], gcount), do: gcount + parser(rest, gcount - 1)
    def parser(["<" | rest], gcount), do: garbage_parser(rest) |> parser(gcount)
    def parser([_ | rest], gcount), do: parser(rest, gcount)

    def garbage_parser(["!", _ | rest]), do: garbage_parser(rest)
    def garbage_parser([">" | rest]), do: rest
    def garbage_parser([_ | rest]), do: garbage_parser(rest)
end