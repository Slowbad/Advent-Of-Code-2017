defmodule AdventOfCode2017.SupportCase do
    use ExUnit.CaseTemplate

    using do
        quote do
            import AdventOfCode2017.SupportCase
        end
    end

    def with_puzzle_input(path, fun) do
        case path |> File.read() do
            {:ok, data} -> fun.(data)
            {:error, _} -> nil
        end
    end
end
