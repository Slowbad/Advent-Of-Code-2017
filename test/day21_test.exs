defmodule AdventOfCode2017.Day21Test do
    use AdventOfCode2017.SupportCase
    doctest Day21

    import Day21

    #@tag :skip
    test "Part 1 works" do
      assert with_puzzle_input("test/input/day21.txt", fn input ->
        assert 186 == input |> part1
      end)
    end

    @tag :skip
    test "Part 2 works" do
      assert with_puzzle_input("test/input/day21.txt", fn input ->
        assert -1 == input |> part2
      end)
    end
end
