defmodule AdventOfCode2017.Day15Test do
    use AdventOfCode2017.SupportCase
    doctest Day15

    import Day15

    @input "Generator A starts with 699\nGenerator B starts with 124"

    @tag :skip
    test "Part 1 works" do
        assert 600 == @input |> part1
    end

    @tag :skip
    test "Part 2 works" do
        assert 313 == @input |> part2
    end
end
