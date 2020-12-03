defmodule Problem3 do
  defp input() do
    {:ok, data} = File.read("problem3.txt")
    data
  end

  defp parse_input() do
    input()
    |> String.split("\n", trim: true)
    |> Stream.map(&String.graphemes/1)
    |> Enum.with_index
  end

  # With a slope (list of rows) we traverse down with a angle of [right and down]
  def find_trees(slopes, angle) do
    right = Enum.at(angle, 0)
    down = Enum.at(angle, 1)
    Enum.reduce(slopes, 0, fn({slope, row}, trees) ->
      # Skip every down:th row
      case rem(row, down) == 0 do
        false ->
          trees
        true -> 
          # Traversing the slope with a angle of right, we find that:
          # col = row * right
          # By using rem (modulo) on the length we can repeat the slope pattern
          # Because we skipped every down:th row, we have to divide the row by down to get our actual row (row index without the skipped rows)
          case Enum.at(slope, rem(trunc(row/down)*right, length(slope))) do
            "." ->
              trees + 0
            "#" ->
              trees + 1
          end
      end
    end)
  end

  def part1() do
    input = parse_input()

    find_trees(input, [3, 1])
  end

  def part2() do
    input = parse_input()

    slopes = [
      [1, 1],
      [3, 1],
      [5, 1],
      [7, 1],
      [1, 2]
    ]

    # Multiply all trees of all slopes
    Enum.reduce(slopes, 1, fn(slope, product) -> product * find_trees(input, slope) end) 
  end
end