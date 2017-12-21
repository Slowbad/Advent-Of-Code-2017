defmodule AdventOfCode2017.Day16Test do
    use AdventOfCode2017.SupportCase
    doctest Day16

    import Day16

    @tag :skip
    test "Part 1 works" do
      assert with_puzzle_input("test/input/day16.txt", fn input ->
        assert "eojfmbpkldghncia" == input |> part1
      end)
    end

    @tag :skip
    test "Part 2 works" do
      assert with_puzzle_input("test/input/day16.txt", fn input ->
        assert "iecopnahgdflmkjb" == input |> part2
      end)
    end
end
