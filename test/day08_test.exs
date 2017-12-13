defmodule AdventOfCode2018.Day08Test do
    use AdventOfCode2017.SupportCase
    doctest Day08

    import Day08

    @tag :skip
    test "Part 1 works" do
        assert with_puzzle_input("test/input/day08.txt", fn input ->
            assert 5221 == input |> part1
        end)
    end

    @tag :skip
    test "Part 2 works" do
        assert with_puzzle_input("test/input/day08.txt", fn input ->
            assert 7491 == input |> part2
        end)
    end

end