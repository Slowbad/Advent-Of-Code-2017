defmodule AdventOfCode2017.Day04 do
    @doc """
        iex> AdventOfCode2017.Day04.part1("aa")
        1

        iex> AdventOfCode2017.Day04.part1("aa\\nbb")
        2

        iex> AdventOfCode2017.Day04.part1("eov awql miv miv eov")
        0
    """
    def part1(input) do
        input
        |> parse_input
        |> count_valid_phrases
    end

    @doc """
        iex> AdventOfCode2017.Day04.parse_input("aa bb\\ncc")
        [["aa", "bb"], ["cc"]]
    """
    def parse_input(input) do
        String.split(input, "\n")
        |> Enum.map(fn(phrase) -> 
            phrase
            |> String.trim
            |> String.split(" ") 
        end)
    end

    def count_valid_phrases(phrases) do
        Enum.count(phrases, &valid_phrase?/1)
    end

    @doc """
        iex> AdventOfCode2017.Day04.valid_phrase?(["aa"])
        true

        iex> AdventOfCode2017.Day04.valid_phrase?(["aa", "aa"])
        false

        iex> AdventOfCode2017.Day04.valid_phrase?(["aa", "aaa"])
        true
    """
    def valid_phrase?(phrase) do
        Enum.uniq(phrase) |> Enum.count == Enum.count(phrase)
    end

    def part2(input) do
        input
        |> parse_input
        |> count_anagram_phrases
    end

    def count_anagram_phrases(phrases) do
        Enum.count(phrases, &valid_anagram_phrase?/1)
    end

    @doc """
        iex> AdventOfCode2017.Day04.valid_anagram_phrase?(["ab", "bc"])
        true

        iex> AdventOfCode2017.Day04.valid_anagram_phrase?(["ab", "ba"])
        false
    """
    def valid_anagram_phrase?(phrase) do
        unq = phrase
        |> Enum.map(fn(word) ->
            word
            |> String.to_charlist
            |> Enum.sort
        end)
        |> Enum.uniq
        |> Enum.count

        unq == length(phrase)
    end
end