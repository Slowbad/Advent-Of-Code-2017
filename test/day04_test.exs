defmodule AdventOfCode2017.Day04Test do
    use AdventOfCode2017.SupportCase
    doctest AdventOfCode2017.Day04

    import AdventOfCode2017.Day04

    test "Part 1 answer" do
        assert with_puzzle_input("test/input/day04.txt", fn input ->
            assert 466 == input |> part1
        end)
    end

    test "Part 2 answer" do
        assert with_puzzle_input("test/input/day04.txt", fn input ->
            assert 251 == input |> part2
        end)
    end
end