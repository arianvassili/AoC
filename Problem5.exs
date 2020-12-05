defmodule Problem5 do
  defp input() do
    {:ok, data} = File.read("problem5.txt")
    data
  end

  defp parse_input() do
    input()
    |> String.split("\n", trim: true)
    |> Enum.map(fn code -> # Parse seat letters to binary code
      code =
        code
        |> String.replace(["F", "L"], "0", global: true) # 0 = lower bounds
        |> String.replace(["B", "R"], "1", global: true) # 1 = upper bounds
      %{"row" => String.slice(code, 0..6), "col" => String.slice(code, 7..-1)}
    end)
  end

  def part1() do
    input = parse_input()
    Enum.reduce(input, 0, fn seat, max -> # Find the maximum seat id
      id = seat_to_id(seat)
      case max > id do
        true ->
          max
        false ->
          id
      end
    end)
  end
  
  def part2() do
    neighbours =
      parse_input()
      |> Enum.map(fn seat ->
        seat_to_id(seat)
      end)
      |> Enum.sort() # Sort the seats
      |> Enum.chunk(2) # Chunk them into 2 neighbours
      |> Enum.find(fn # Find 2 list neighbours that has someone between them
        [id1, id2] when id2 - id1 != 1 -> true
        _ -> false
      end)
    Enum.at(neighbours, 0) + 1 # This is us!
  end

  defp seat_to_id(%{"row" => row, "col" => col}) do
    {row, _} = Integer.parse(row, 2)
    {col, _} = Integer.parse(col, 2)

    row * 8 + col # Seat id = row*8 + col
  end
end