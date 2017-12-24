defmodule AdventOfCode2017.Day18Test do
    use AdventOfCode2017.SupportCase
    doctest Day18

    import Day18

    @tag :skip
    test "Part 1 works" do
      assert with_puzzle_input("test/input/day18.txt", fn input ->
        assert 3188 == input |> part1
      end)
    end

    @tag :skip
    test "Part 2 works" do
      assert with_puzzle_input("test/input/day18.txt", fn input ->
        assert -1 == input |> part1
      end)
    end
end
