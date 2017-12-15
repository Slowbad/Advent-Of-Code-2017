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
            assert -1 == input |> part2
        end)
    end

    @tag :skip
    test "part 2 correctness" do
        assert 10 == "0: 3\n1: 2\n4: 4\n6: 4" |> part2
    end
end