defmodule AdventOfCode2017.Day23Test do
    use AdventOfCode2017.SupportCase
    doctest Day23

    import Day23

    @tag :skip
    test "Part 1 works" do
      assert with_puzzle_input("test/input/day23.txt", fn input ->
        assert 4225 == input |> part1
      end)
    end

    @tag :skip
    test "Part 2 works" do
      assert 905 == part2()
    end
end
