defmodule AdventOfCode2017.Day07Test do
    use AdventOfCode2017.SupportCase
    doctest Day07

    import Day07

    @tag :skip
    test "Part 1 works" do
        assert with_puzzle_input("test/input/day07.txt", fn input ->
            assert "veboyvy" == input |> part1
        end)
    end

    @tag :skip
    test "Part 2 works" do
        assert with_puzzle_input("test/input/day07.txt", fn input ->
            assert 749 == input |> part2
        end)
    end
end