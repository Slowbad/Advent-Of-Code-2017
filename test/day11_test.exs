defmodule AdventOfCode2017.Day11Test do
    use AdventOfCode2017.SupportCase
    doctest Day11

    import Day11

    # @tag :skip
    test "Part 1 works" do
        assert with_puzzle_input("test/input/day11.txt", fn input ->
            assert 675 == input |> part1
        end)
    end

    @tag :skip
    test "Part 2 works" do
        assert with_puzzle_input("test/input/day11.txt", fn input ->
            assert 0 == input |> part2
        end)
    end

end