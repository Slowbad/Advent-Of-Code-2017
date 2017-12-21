defmodule AdventOfCode2017.Day17Test do
    use AdventOfCode2017.SupportCase
    doctest Day17

    import Day17

    @input 366

    # @tag :skip
    test "Part 1 works" do
      assert 1025 == @input |> part1
    end

    @tag :skip
    test "Part 2 works" do
      assert -1 == @input |> part2
    end
end
