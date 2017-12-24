defmodule AdventOfCode2017.Day19Test do
    use AdventOfCode2017.SupportCase
    doctest Day19

    import Day19

    #@tag :skip
    test "Part 1 works" do
      assert with_puzzle_input("test/input/day19.txt", fn input ->
        assert "EPYDUXANIT" == input |> part1
      end)
    end

    @tag :skip
    test "Part 2 works" do
      assert with_puzzle_input("test/input/day19.txt", fn input ->
        assert -1 == input |> part1
      end)
    end
end
