defmodule AdventOfCode2017.Day20Test do
    use AdventOfCode2017.SupportCase
    doctest Day20

    import Day20

    @tag :skip
    test "Part 1 works" do
      assert with_puzzle_input("test/input/day20.txt", fn input ->
        assert 150 == input |> part1
      end)
    end

    @tag :skip
    test "Part 2 works" do
      assert with_puzzle_input("test/input/day20.txt", fn input ->
        assert 657 == input |> part2
      end)
    end
end
