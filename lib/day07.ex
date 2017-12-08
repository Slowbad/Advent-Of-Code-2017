defmodule Day07 do
    
    def part1(input) do
        input
        |> parse_input
        |> find_root
    end

    def part2(input) do
        nodes = input
        |> parse_input

        nodes
        |> build_tree(find_root(nodes))
        |> weigh_tree
        |> find_unbalanced_node
        |> correction
    end

    @doc """
        iex> Day07.parse_input("abcd (55)\\nefghi (3) -> abcd, zxcv")
        %{"abcd" => {55, []}, "efghi" => {3, ["abcd", "zxcv"]}}
    """
    def parse_input(input) do
        input
        |> String.trim
        |> String.split("\n")
        |> Enum.map(fn(s) ->
            matches = Regex.named_captures(~r/(?<name>\w+) \((?<weight>\d+)\)( -> (?<children>[\w|,| ]+))?/, s)

            {
                matches["name"], 
                {
                    String.to_integer(matches["weight"]), 
                    parse_children(matches["children"])
                }
            }
        end)
        |> Enum.into(%{})
    end

    def parse_children(""), do: []
    def parse_children(children), do: children |> String.split(", ")

    @doc """
        iex> Day07.find_root(%{"abcd" => {55, []}, "efghi" => {3, ["abcd"]}})
        "efghi"
    """
    def find_root(nodes) do
        find_root(nodes |> Map.keys |> List.first, nodes)
    end
    def find_root(name, nodes) do
        case Enum.find(nodes, fn({_, {_, children}}) -> name in children end) do
            nil -> name
            {name, _} -> find_root(name, nodes)
        end
    end

    def build_tree(nodes, name) do
        {weight, children} = nodes[name]
        {name, weight, Enum.map(children, &build_tree(nodes, &1))}
    end

    def weigh_tree({name, weight, children}) do
        children_with_total_weight = Enum.map(children, &weigh_tree/1)

        total_weight = 
            Enum.reduce(children_with_total_weight, weight, fn({_, _, child_total_weight, _}, sum) ->
                sum + child_total_weight
            end)
        
        {name, weight, total_weight, children_with_total_weight}
    end

    def find_unbalanced_node({name, weight, total_weight, children}, balanced \\ []) do
        groups = Enum.group_by(children, &elem(&1, 2))

        case map_size(groups) do
            1 ->
                [{_, _, correct_weight, _} | _] = balanced
                {name, weight, total_weight, correct_weight}

            2 ->
                {unbalanced, balanced} = extract_unbalanced_and_balanced(groups)
                find_unbalanced_node(unbalanced, balanced)
        end
    end

    def extract_unbalanced_and_balanced(groups) do
        Enum.reduce(groups, {nil, nil}, fn({_, list}, {unbalanced, balanced}) ->
            case length(list) do
                1 -> {hd(list), balanced}
                _ -> {unbalanced, list}
            end
        end)
    end

    def correction({_, my_weight, wrong_weight, correct_weight}) do
        my_weight + correct_weight - wrong_weight
    end
end