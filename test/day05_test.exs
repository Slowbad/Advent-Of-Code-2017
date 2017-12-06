defmodule AdventOfCode2017.Day05Test do
    use AdventOfCode2017.SupportCase
    doctest AdventOfCode2017.Day05
    doctest AdventOfCode2017.Day05.State

    alias AdventOfCode2017.Day05.State

    import AdventOfCode2017.Day05

    test "Part 1 works" do
        assert with_puzzle_input("test/input/day05.txt", fn input ->
            assert 394829 == input |> part1
        end)
    end

    @tag :skip # Takes too long to finish
    test "Part 2 works" do
        assert with_puzzle_input("test/input/day05.txt", fn input ->
            assert 31150702 == input |> part2
        end)
    end

    test "doesn't move when 0" do
        state = %State { jumps: %{0 => 0}, jump_count: 1 }

        new_state = traverse1(state)
        assert new_state.position == 0
        assert new_state.jumps[0] == 1
    end

    test "jumps forward when positive" do
        state = %State { jumps: %{0 => 1}, jump_count: 2 }
        new_state = traverse1(state)

        assert new_state.position == 1
        assert new_state.jumps[0] == 2
    end

    test "jumps back when negative" do
        state = %State { jumps: %{0 => -1}, jump_count: 1 }
        new_state = traverse1(state)

        assert new_state.position == -1
        assert new_state.jumps[0] == 0
    end

end