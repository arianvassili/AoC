defmodule Problem6 do
  defp parse_input() do
    {:ok, data} = File.read("problem6.txt")
    data
    |> String.split("\n\n") # Each double newline = one group
  end

  # Copied from Enum.frequencies
  def frequencies(enumerable) do
    Enum.reduce(enumerable, %{}, fn key, acc ->
      case acc do
        %{^key => value} -> %{acc | key => value + 1}
        %{} -> Map.put(acc, key, 1)
      end
    end)
  end

  defp unique_answers(answer) do
    answer
    |> Enum.join("")
    |> String.graphemes()
    |> frequencies() # Grouping the answers to their frequency
    |> Enum.map( fn {k,_v} -> k  end) # Remove the frequency
    |> length() # Count the answers
  end

  defp unanimous_answers(answer) do
    answer
    |> Enum.join("")
    |> String.graphemes()
    |> frequencies() # Grouping the answers to their frequency
    |> Enum.filter(fn {_k,v} ->  v == length(answer) end) # Filter the unanimous answers
    |> Enum.map( fn {k,_v} -> k  end) # Remove the frequency
    |> length() # Count the answers
  end

  def part1() do
    parse_input()
    |> Enum.map(&String.split(&1, "\n")) # Split answers for each group
    |> Enum.map(&unique_answers/1) # Extract the unique answers
    |> Enum.reduce(0, fn(unique_answer, tot) -> tot + unique_answer end) 
  end

  def part2() do
    parse_input()
    |> Enum.map(&String.split(&1, "\n")) # Split answers for each group
    |> Enum.map(&unanimous_answers/1) # Extract the unianimous answers
    |> Enum.reduce(0, fn(unanimous_answer, tot) -> tot + unanimous_answer end) 
  end
end