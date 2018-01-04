defmodule AdventOfCode2017.Day22Test do
    use AdventOfCode2017.SupportCase
    doctest Day22

    import Day22

    #@tag :skip
    test "Part 1 works" do
      assert with_puzzle_input("test/input/day22.txt", fn input ->
        assert 5261 == input |> part1
      end)
    end

    @tag :skip
    test "Part 2 works" do
      assert with_puzzle_input("test/input/day22.txt", fn input ->
        assert -1 == input |> part2
      end)
    end
end
