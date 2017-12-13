defmodule AdventOfCode2019.Day08Test do
    use AdventOfCode2017.SupportCase
    doctest Day09

    import Day09

    # @tag :skip
    test "Part 1 works" do
        assert with_puzzle_input("test/input/day09.txt", fn input ->
            assert 17537 == input |> part1
        end)
    end

    @tag :skip
    test "Part 2 works" do
        assert with_puzzle_input("test/input/day09.txt", fn input ->
            assert -1 == input |> part2
        end)
    end

end