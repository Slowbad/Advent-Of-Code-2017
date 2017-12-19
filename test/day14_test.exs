defmodule AdventOfCode2017.Day14Test do
    use AdventOfCode2017.SupportCase
    doctest Day14

    import Day14

    @input "oundnydw"

    #@tag :skip
    test "Part 1 works" do
        assert 8106 == @input |> part1
    end

    @tag :skip
    test "Part 2 works" do
        assert -1 == @input |> part2
    end
end
