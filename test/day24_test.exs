defmodule AdventOfCode2017.Day24Test do
    use AdventOfCode2017.SupportCase
    doctest Day24

    import Day24

    @tag :skip
    test "Part 1 works" do
      assert with_puzzle_input("test/input/day24.txt", fn input ->
        assert 1868 == input |> part1
      end)
    end

    @tag :skip
    test "Part 2 works" do
      assert with_puzzle_input("test/input/day24.txt", fn input ->
        assert 1841 == input |> part2
      end)
    end
end
