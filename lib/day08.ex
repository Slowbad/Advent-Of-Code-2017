defmodule Day08 do
    @doc ~S"""
        iex> Day08.part1("b inc 5 if a > 1\na inc 1 if b < 5\nc dec -10 if a >= 1\nc inc -20 if c == 10")
        1
    """
    def part1(input) do
        input
        |> parse_input
        |> run
        |> find_largest_register
    end

    def part2(input) do

    end

    def parse_input(input) do
        input
        |> String.trim
        |> String.split("\n")
        |> Enum.map(&line/1)
    end

    def line(str) do
        m = Regex.named_captures(~r/(?<register>\w+) (?<operator>inc|dec) (?<operand>-?\d+) if (?<cond_register>\w+) (?<cond_operator>[=|!|<|>]{1,2}) (?<cond_operand>-?\d+)/, str)
        {
            m["register"], 
            String.to_atom(m["operator"]), 
            String.to_integer(m["operand"]), 
            m["cond_register"], 
            String.to_atom(m["cond_operator"]), 
            String.to_integer(m["cond_operand"])
        }
    end

    def run(instructions) do
        Enum.reduce(instructions, %{}, fn(instruction, registers) ->
            if valid_condition?(instruction, registers) do
                perform_operation(instruction, registers)
            else
                registers
            end
        end)
    end

    def valid_condition?({_, _, _, register, operand, operator}, registers) do
        value = Map.get(registers, register, 0)
        case operand do
            :== -> value == operator
            :!= -> value != operator
            :<= -> value <= operator
            :>= -> value >= operator
            :< -> value < operator
            :> -> value > operator
            _ -> raise ArgumentError, message: "Invalid operand: #{operand}"
        end
    end

    def perform_operation({register, operand, operator, _, _, _}, registers) do
        value = Map.get(registers, register, 0)
        Map.put(registers, register, maths(operand, value, operator))
    end

    def maths(:inc, a, b), do: a + b
    def maths(:dec, a, b), do: a - b

    def find_largest_register(registers) do
        registers
        |> Map.values
        |> Enum.max
    end
end