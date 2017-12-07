defmodule Day07 do
    
    def part1(input) do
        input
        |> parse_input
        |> find_root
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

    def parse_children(children) when byte_size(children) == 0, do: []
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

    @doc """
        iex> Day07.weigh_node("abcd", %{"abcd" => {55, ["efgh"]}, "efgh" => {3, []}})
        58
    """
    def weigh_node(name, nodes) do
        get_children(name, nodes)
        |> Enum.map(&weigh_node(&1, nodes))
        |> Enum.sum 
        |> Kernel.+(nodes[name] |> elem(0))
    end

    def get_children(name, nodes), do: nodes[name] |> elem(1)

    @doc """
        iex> Day07.find_unbalanced_node(%{"abcd" => {55, ["efgh", "zxcv"]}, "efgh" => {3, []}, "zxcv" => {4, []}})
        "efgh"
    """
    def find_unbalanced_node(nodes) do

    end
end