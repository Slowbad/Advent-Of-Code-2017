defmodule Day12 do
    defmodule Program do
        defstruct [
            id: :missing_id,
            visited: false,
            neighbors: []
        ] 

        @doc """
            iex> Day12.Program.connected(%{ 0 => %Day12.Program{id: 0, neighbors: [1]}, 1 => %Day12.Program{id: 1, neighbors: [0]}}, 1)
            true

            iex> Day12.Program.connected(%{ 0 => %Day12.Program{id: 0, neighbors: []}, 1 => %Day12.Program{id: 1, neighbors: [1]}}, 1)
            false
        """
        def connected(programs, lookup) when is_integer(lookup), do: connected(programs, [lookup])
        def connected(_programs, [0 | _rest]), do: true
        def connected(_programs, []), do: false
        def connected(programs, [lookup | rest]) do
            prog = struct(programs[lookup], visited: true)
            programs = Map.put(programs, lookup, prog)

            unvisted_neighbors = prog.neighbors
            |> Enum.map(&Map.get(programs, &1))
            |> Enum.filter(fn(p) -> not p.visited end)
            |> Enum.map(fn(p) -> p.id end)

            connected(programs, rest ++ unvisted_neighbors)
        end

        @doc """
            iex> Day12.Program.cull_connected(%{ 0 => %Day12.Program{id: 0, neighbors: [1]}, 1 => %Day12.Program{id: 1, neighbors: [0]}, 2 => %Day12.Program{id: 2, neighbors: [2]}}, 1)
            %{2 => %Day12.Program{id: 2, neighbors: [2]}}

            iex> Day12.Program.cull_connected(%{2 => %Day12.Program{id: 2, neighbors: [2]}}, 2)
            %{}
        """
        def cull_connected(programs, lookup) when is_integer(lookup), do: cull_connected(programs, [lookup])
        def cull_connected(programs, []), do: programs
        def cull_connected(programs, [lookup | rest]) do
            {program, programs} = Map.pop(programs, lookup)

            valid_neighbors = 
                program.neighbors
                |> Enum.filter(fn(neighbor) ->
                    not neighbor in rest and programs[neighbor] != nil
                end)

            programs
            |> cull_connected(rest ++ valid_neighbors)
        end
    end

    def part1(input) do
        programs = input |> parse_input

        programs
        |> Map.keys
        |> Enum.count(&Program.connected(programs, &1))
    end

    def part2(input) do
        input
        |> parse_input
        |> count_groups
    end

    @doc """
        iex> Day12.count_groups(%{ 0 => %Day12.Program{id: 0, neighbors: [1]}, 1 => %Day12.Program{id: 1, neighbors: [0]}, 2 => %Day12.Program{id: 2, neighbors: [2]}})
        2
    """
    def count_groups(programs), do: count_groups(programs, 0)
    def count_groups(programs, count) when map_size(programs) == 0, do: count
    def count_groups(programs, count) do
        id = programs
        |> Map.keys
        |> hd

        programs
        |> Program.cull_connected(id)
        |> count_groups(count + 1)
    end

    @doc """
        iex> Day12.parse_input("0 <-> 1, 2\\n1 <-> 0, 2")
        %{ 0 => %Day12.Program{id: 0, neighbors: [1, 2]}, 1 => %Day12.Program{id: 1, neighbors: [0, 2]}}
    """
    def parse_input(input) do
        input
        |> String.trim
        |> String.split("\n")
        |> Enum.reduce(%{}, fn(s, programs) ->
            [id | neighbors] = s
            |> String.split(~r/( <-> |, )/)
            |> Enum.map(&String.to_integer/1)

            Map.put(programs, id, %Day12.Program{id: id, neighbors: neighbors})
        end)
    end
end