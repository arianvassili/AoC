defmodule Problem4 do
  defp parse_input() do
    {:ok, data} = File.read("problem4.txt")
    data
    |> String.split("\n\n") # Each double newline = one entry
    |> Stream.map(&Enum.join(String.split(&1, "\n"), " ")) # Remove the single newlines
    |> Stream.map(&String.split(&1, " ")) # Split on space
  end

  # ["xx:yy", ..] => %{"xx" => "yy", ..}
  defp pairs_to_map(pairs) do
    pairs
    |> Enum.map(&String.split(&1, ":")) # Split on :
    |> Map.new(&List.to_tuple/1) # Convert to %Map
  end

  # Must include these patterns
  defp correct_pass_part1(%{"byr" => _, "ecl" => _, "eyr" => _, "hcl" => _, "hgt" => _, "iyr" => _, "pid" => _}) do
    true
  end
  defp correct_pass_part1(_any) do
    false
  end

  # Has data validations
  defp correct_pass_part2(%{"byr" => byr, "ecl" => ecl, "eyr" => eyr, "hcl" => hcl, "hgt" => hgt, "iyr" => iyr, "pid" => pid}) do
    try do # Naively try to do all parses
      # byr (Birth Year) - four digits; at least 1920 and at most 2002.
      byr = String.to_integer(byr)
      if (byr < 1919 or byr > 2002) do
        throw "fail"
      end
      # iyr (Issue Year) - four digits; at least 2010 and at most 2020.
      iyr = String.to_integer(iyr)
      if (iyr < 2010 or iyr > 2020) do
        throw "fail"
      end
      # eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
      eyr = String.to_integer(eyr)
      if (eyr < 2020 or eyr > 2030) do
        throw "fail"
      end
      # hgt (Height) - a number followed by either cm or in:
      cond do
        String.ends_with?(hgt, "cm") ->
          hgt = List.first(String.split(hgt, "cm"))
          # If cm, the number must be at least 150 and at most 193.
          hgt = String.to_integer(hgt)
          if (hgt < 150 or hgt > 193) do
            throw "fail"
          end
        String.ends_with?(hgt, "in") ->
          hgt = List.first(String.split(hgt, "in"))
          # If in, the number must be at least 59 and at most 76.
          hgt = String.to_integer(hgt)
          if (hgt < 59 or hgt > 76) do
            throw "fail"
          end
        true ->
          throw "fail"
      end
      # hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
      if String.starts_with?(hcl, "#") do
        hcl = String.slice(hcl, 1..-1) # Slice everything after #
        if String.length(hcl) == 6 do
          accepted_graphemes = "0123456789abcdef"
          hcl = Enum.filter(String.graphemes(hcl), fn char -> Enum.member?(String.graphemes(accepted_graphemes), char) end)
          if length(hcl) != 6 do
            throw "fail"
          end
        else
          throw "fail"
        end
      else
        throw "fail"
      end
      # ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
      accepted_eye_colors = "amb blu brn gry grn hzl oth"
      if not Enum.member?(String.split(accepted_eye_colors, " "), ecl) do
        throw "fail"
      end
      # pid (Passport ID) - a nine-digit number, including leading zeroes.
      if String.length(pid) != 9 do
        throw "fail"
      end
      String.to_integer(pid)
      # All parses valid, return true
      true
    catch # If any of the naive parses is not valid, catch and return false
      _catch -> false
    end
  end
  defp correct_pass_part2(_any) do
    false
  end

  def part1() do
    input = parse_input()
    Enum.count(input, fn pass -> correct_pass_part1(pairs_to_map(pass)) end)
  end

  def part2() do
    input = parse_input()
    Enum.count(input, fn pass -> correct_pass_part2(pairs_to_map(pass)) end)
  end
end