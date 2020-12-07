defmodule Problem7 do
  defp parse_input() do
    {:ok, data} = File.read("problem7.txt")
    data
    |> String.split(".\n", trim: true) # Each newline = one bag
    |> bags_to_tree() # Convert bags to a list of each bag and its children
  end

  defp bags_to_tree(bags) do
    bags_to_tree(bags, [])
  end
  defp bags_to_tree([], tree) do
    Map.new(tree)
  end
  defp bags_to_tree([bag | bags], tree) do
    [node, child_string] = String.split(bag, " bags contain ")
    bags_to_tree(bags, [{node, parse_children(child_string)} | tree])
  end

  # 3 bright white bags, 4 muted yellow bags -> [{3, "bright white"}, {4, "muted yellow}]
  def parse_children(child_string) when is_binary(child_string) do
    child_string
    |> String.split(", ")
    |> parse_children()
  end
  def parse_children(["no other bags"]), do: []
  def parse_children(["no other bags."]), do: []
  def parse_children(list) do
    list
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [count, bag_type, bag_color, _bag] -> {String.to_integer(count), bag_type <> " " <> bag_color} end)
  end

  def invert_tree(tree) do
    Enum.reduce(tree, %{}, fn {parent, children}, inverted_tree ->
      Enum.reduce(children, inverted_tree, fn {_n, child}, inverted_tree ->
        Map.update(inverted_tree, child, [parent], &[parent | &1])
      end)
    end)
  end

  # Init empty return list
  def all_parents_of(tree, node) do
    all_parents_of(tree, node, [])
  end
  # Check node uniqueness, add all unique nodes (parents + initial node) to unique_parents
  def all_parents_of(tree, node, unique_parents) when is_binary(node) do
    case Enum.member?(unique_parents, node) do
      true ->
        find_unique_parents(tree, tree[node], unique_parents)
      false ->
        find_unique_parents(tree, tree[node], [node | unique_parents])
    end
  end

  def find_unique_parents(tree, nil, unique_parents) do
    unique_parents
  end
  def find_unique_parents(tree, [], unique_parents) do
    unique_parents
  end
  # Traverse the parent nodes
  def find_unique_parents(tree, [node | nodes], unique_parents) do
    find_unique_parents(tree, nodes, all_parents_of(tree, node, unique_parents))
  end
  # Keep traversing the tree
  def find_unique_parents(tree, node, unique_parents) do
    all_parents_of(tree, node, unique_parents)
  end
  
  # Tabulate the children, add the counts
  def count_children(tree, child) do
    Enum.reduce(tree[child], 0, fn {size, child_node}, count ->
      count + size + (size * count_children(tree, child_node))
    end)
  end

  def part1() do
    nodes =
      parse_input()
      |> invert_tree() # Invert the tree, so we start at the nodes/leafes
      |> all_parents_of("shiny gold") # Start from shiny gold and traverse all parents
      |> length # Get length (including shiny gold)
    nodes - 1
  end

  def part2() do
    parse_input() # This time we start at the head of the tree
    |> count_children("shiny gold")
  end
end