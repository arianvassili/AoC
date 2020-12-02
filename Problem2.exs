defmodule Problem2 do
  # "1-3 g: fgdgdfg\n..." -> ["1-3", "g:", "fgdgdfg", ...]
  defp parse_input() do
    {:ok, data} = File.read("problem2.txt")
    data
    |> String.split("\n")
    |> Stream.map(&String.split(&1, " "))
  end

  # "3-4" -> [3, 4]
  defp parse_limits(line) do
    line
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
  end

  # "g:" -> "g" 
  defp parse_character(line) do
    line
    |> String.split(":")
    |> Enum.at(0)
  end

  # "sdfsdfsf", "s" -> "sss"
  defp parse_password(line, character) do
    line
    |> String.graphemes
    |> Enum.reject(fn x -> x != character end)
    |> Enum.join
  end

  defp correct_pass_part1(line) do
    limits = parse_limits(Enum.at(line, 0))
    character = parse_character(Enum.at(line, 1))
    password = parse_password(Enum.at(line, 2), character)
    length = String.length(password)

    (length > Enum.at(limits, 0)-1 and length < Enum.at(limits, 1)+1) 
  end

  defp correct_pass_part2(line) do
    limits = parse_limits(Enum.at(line, 0))
    character = parse_character(Enum.at(line, 1))
    password = String.graphemes(Enum.at(line, 2))

    first_pos = Enum.at(password, Enum.at(limits, 0)-1) == character
    second_pos = Enum.at(password, Enum.at(limits, 1)-1) == character

    first_pos != second_pos
  end

  def part1() do
    input = parse_input()
    Enum.count(input, fn x -> correct_pass_part1(x) end)
  end

  def part2() do
    input = parse_input()
    Enum.count(input, fn x -> correct_pass_part2(x) end)
  end
end