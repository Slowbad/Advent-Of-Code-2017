defmodule AdventOfCode2017.Day12Test do
    use AdventOfCode2017.SupportCase
    doctest Day12
    doctest Day12.Program

    import Day12

    @tag :skip
    test "Part 1 works" do
        assert with_puzzle_input("test/input/day12.txt", fn input ->
            assert 145 == input |> part1
        end)
    end

    @tag :skip
    test "Part 2 works" do
        assert with_puzzle_input("test/input/day12.txt", fn input ->
            assert 207 == input |> part2
        end)
    end
end