defmodule AdventOfCode2017.Day06Test do
    use AdventOfCode2017.SupportCase
    doctest AdventOfCode2017.Day06

    import AdventOfCode2017.Day06

    test "Part 1 works" do
        assert with_puzzle_input("test/input/day06.txt", fn input ->
            assert 3156 == input |> part1
        end)
    end
end