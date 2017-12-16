defmodule AdventOfCode2017.Day13Test do
    use AdventOfCode2017.SupportCase
    doctest Day13

    import Day13

    @tag :skip
    test "Part 1 works" do
        assert with_puzzle_input("test/input/day13.txt", fn input ->
            assert 632 == input |> part1
        end)
    end

    @tag :skip
    test "Part 2 works" do
        assert with_puzzle_input("test/input/day13.txt", fn input ->
            assert 3849742 == input |> part2
        end)
    end
end
