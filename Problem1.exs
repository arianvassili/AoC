defmodule Problem1 do
  defp input() do
    {:ok, data} = File.read("problem1.txt")
    data
  end

  defp parse_input() do
    input()
    |> String.split("\n", trim: true)
    |> Stream.map(&String.to_integer/1)
  end

  def part1() do
    input = parse_input()
    # One input must be below 1010, and one above 1010
    first_half = Enum.filter(input, fn x -> x < 1010 end)
    second_half = Enum.filter(input, fn x -> x > 1010 end)

    [{x, y} | _] = for x <- first_half, y <- second_half, x + y == 2020, do: {x, y}
    x * y
  end

  def part2() do
    input = parse_input()
    # Atleast one input must be below 2020/3
    below_third = Enum.filter(input, fn x -> x < 2020/3 end) 
    # Atleast one input must be above 2020/3
    above_third = Enum.filter(input, fn x -> x > 2020/3 end)
    # Last input can be either

    [{x, y, z} | _] = for x <- below_third, y <- above_third, z <- input, x + y + z == 2020, do: {x, y, z}
    x * y * z
  end
end