defmodule RedBlackTree do
  @moduledoc """
  Implementation of a LLRB Red-Black Tree node.
  (Left-Leaning Red-Black Tree)
  Time complexity (hopefully):
    - insertion: O(log(N))
    - deletion: O(log(N))
    - lookup: O(log(N))
  """

  defstruct color: :black, key: nil, value: nil, left: nil, right: nil

  @type color :: :red | :black
  @type t :: %RedBlackTree{
          color: color,
          key: any(),
          value: any(),
          left: t() | nil,
          right: t() | nil
        }

  # FILTER OPERATION
  @spec filter(t() | nil, (any(), any() -> boolean())) :: t() | nil
  def filter(nil, _func), do: nil

  def filter(%RedBlackTree{key: key, value: value, left: left, right: right} = node, func) do
    left_filtered = filter(left, func)
    right_filtered = filter(right, func)

    if func.(key, value) do
      %RedBlackTree{
        color: node.color,
        key: key,
        value: value,
        left: left_filtered,
        right: right_filtered
      }
    else
      # Merge the filtered subtrees without the current node
      merge(left_filtered, right_filtered)
    end
  end

  # MAP OPERATION
  @spec map(t() | nil, (any(), any() -> any())) :: t() | nil
  def map(nil, _func), do: nil

  def map(%RedBlackTree{key: key, value: value, left: left, right: right} = node, func) do
    mapped_value = func.(key, value)

    %RedBlackTree{
      color: node.color,
      key: key,
      value: mapped_value,
      left: map(left, func),
      right: map(right, func)
    }
  end

  # LEFT FOLD OPERATION
  @spec foldl(t() | nil, acc :: any(), (any(), any(), acc :: any() -> any())) :: any()
  def foldl(nil, acc, _func), do: acc
  def foldl([], acc, _func), do: acc

  def foldl(%RedBlackTree{key: key, value: value, left: left, right: right}, acc, func) do
    acc = foldl(left, acc, func)
    acc = func.(key, value, acc)
    foldl(right, acc, func)
  end

  # RIGHT FOLD OPERATION
  @spec foldr(t() | nil, acc :: any(), (any(), any(), acc :: any() -> any())) :: any()
  def foldr(nil, acc, _func), do: acc
  def foldr([], acc, _func), do: acc

  def foldr(%RedBlackTree{key: key, value: value, left: left, right: right}, acc, func) do
    acc = foldr(right, acc, func)
    acc = func.(key, value, acc)
    foldr(left, acc, func)
  end

  # MERGE TWO TREES
  @spec merge(t() | nil, t() | nil, (any(), any(), any() -> any())) :: t() | nil
  def merge(left_tree, right_tree, value_merge_fun \\ &default_value_merge_fun/3)

  def merge(nil, tree, _value_merge_fun), do: tree
  def merge(tree, nil, _value_merge_fun), do: tree

  def merge(left_tree, right_tree, value_merge_fun) do
    # Collect key-value pairs from both trees
    kv_pairs_left = to_list(left_tree)
    kv_pairs_right = to_list(right_tree)

    # Combine key-value pairs
    kv_pairs_combined =
      (kv_pairs_left ++ kv_pairs_right)
      |> Enum.group_by(fn {key, _value} -> key end, fn {_key, value} -> value end)
      |> Enum.map(fn {key, values} ->
        # Merge values for the same key using the value_merge_fun
        merged_value = Enum.reduce(values, &value_merge_fun.(key, &1, &2))
        {key, merged_value}
      end)

    # Sort key-value pairs to ensure consistent insertion order
    kv_pairs_sorted = Enum.sort_by(kv_pairs_combined, fn {key, _value} -> key end)

    # Build a new tree from the sorted key-value pairs
    Enum.reduce(kv_pairs_sorted, nil, fn {key, value}, acc ->
      insert(acc, key, value)
    end)
  end

  def to_list(nil), do: []

  def to_list(%RedBlackTree{left: left, right: right, key: key, value: value}) do
    to_list(left) ++ [{key, value}] ++ to_list(right)
  end

  defp default_value_merge_fun(_key, v1, v2) do
    # Combine the values into a list, remove duplicates, and sort them
    [v1, v2]
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.sort()
  end

  # LOOKUP OPERATION
  @spec get(t() | nil, any()) :: any() | nil
  def get(nil, _key), do: nil

  def get(%RedBlackTree{key: k, value: v, left: left, right: right}, key) do
    cond do
      key == k -> v
      key < k -> get(left, key)
      true -> get(right, key)
    end
  end

  # INSERT OPERATION
  @spec insert(t() | nil, any(), any()) :: t()
  def insert(tree, key, value) do
    tree
    |> do_insert(key, value)
    |> ensure_black_root()
  end

  defp do_insert(nil, key, value) do
    %RedBlackTree{color: :red, key: key, value: value}
  end

  defp do_insert(%RedBlackTree{key: k} = node, key, value) do
    node =
      cond do
        key == k ->
          %RedBlackTree{node | value: value}

        key < k ->
          %RedBlackTree{node | left: do_insert(node.left, key, value)}

        true ->
          %RedBlackTree{node | right: do_insert(node.right, key, value)}
      end

    balance(node)
  end

  defp ensure_black_root(%RedBlackTree{color: :red} = tree) do
    %RedBlackTree{tree | color: :black}
  end

  defp ensure_black_root(tree), do: tree

  # DELETE OPERATION
  @spec delete(t() | nil, any()) :: t() | nil
  def delete(tree, key) do
    if tree == nil do
      nil
    else
      tree = do_delete(tree, key)

      if tree != nil do
        %RedBlackTree{tree | color: :black}
      else
        nil
      end
    end
  end

  defp do_delete(nil, _key), do: nil

  defp do_delete(node, key) do
    node =
      if key < node.key do
        node = move_red_left_if_needed(node)
        %RedBlackTree{node | left: do_delete(node.left, key)}
      else
        node
        |> rotate_right_if_needed()
        |> handle_delete_right(key)
      end

    if node != nil do
      balance(node)
    else
      nil
    end
  end

  defp handle_delete_right(node, key) do
    if key == node.key and node.right == nil do
      # Node to delete found and has no right child
      nil
    else
      node = move_red_right_if_needed(node)

      node =
        if key == node.key do
          # Node to delete found
          min_node = min(node.right)

          %RedBlackTree{
            node
            | key: min_node.key,
              value: min_node.value,
              right: delete_min(node.right)
          }
        else
          %RedBlackTree{node | right: do_delete(node.right, key)}
        end

      node
    end
  end

  defp move_red_left_if_needed(node) do
    if node.left != nil and not red?(node.left) and not red?(node.left.left) do
      move_red_left(node)
    else
      node
    end
  end

  defp move_red_right_if_needed(node) do
    if node.right != nil and not red?(node.right) and not red?(node.right.left) do
      move_red_right(node)
    else
      node
    end
  end

  defp rotate_right_if_needed(node) do
    if red?(node.left) do
      rotate_right(node)
    else
      node
    end
  end

  # MOVE RED LEFT
  defp move_red_left(node) do
    node = flip_colors(node)

    node =
      if node.right != nil and red?(node.right.left) do
        node = %RedBlackTree{node | right: rotate_right(node.right)}
        node = rotate_left(node)
        flip_colors(node)
      else
        node
      end

    node
  end

  # MOVE RED RIGHT
  defp move_red_right(node) do
    node = flip_colors(node)

    node =
      if node.left != nil and red?(node.left.left) do
        node = rotate_right(node)
        flip_colors(node)
      else
        node
      end

    node
  end

  # FIND MINIMUM NODE
  defp min(node) do
    if node.left == nil do
      node
    else
      min(node.left)
    end
  end

  # DELETE MINIMUM NODE
  defp delete_min(node) do
    if node.left == nil do
      nil
    else
      node =
        if not red?(node.left) and not red?(node.left.left) do
          move_red_left(node)
        else
          node
        end

      node = %RedBlackTree{node | left: delete_min(node.left)}
      balance(node)
    end
  end

  # ROTATIONS AND BALANCING
  defp rotate_left(%RedBlackTree{right: right} = h) do
    %RedBlackTree{
      color: h.color,
      key: right.key,
      value: right.value,
      left: %RedBlackTree{h | right: right.left, color: :red},
      right: right.right
    }
  end

  defp rotate_right(%RedBlackTree{left: left} = h) do
    %RedBlackTree{
      color: h.color,
      key: left.key,
      value: left.value,
      left: left.left,
      right: %RedBlackTree{h | left: left.right, color: :red}
    }
  end

  defp flip_colors(%RedBlackTree{left: left, right: right} = h) do
    %RedBlackTree{
      h
      | color: toggle_color(h.color),
        left: recolor(left),
        right: recolor(right)
    }
  end

  defp balance(node) do
    node =
      if red?(node.right) do
        rotate_left(node)
      else
        node
      end

    node =
      if red?(node.left) and red?(node.left.left) do
        rotate_right(node)
      else
        node
      end

    node =
      if red?(node.left) and red?(node.right) do
        flip_colors(node)
      else
        node
      end

    node
  end

  # HELPER FUNCTIONS
  defp red?(%RedBlackTree{color: :red}), do: true
  defp red?(_), do: false

  defp recolor(nil), do: nil

  defp recolor(%RedBlackTree{color: color} = node) do
    %RedBlackTree{node | color: toggle_color(color)}
  end

  defp toggle_color(:red), do: :black
  defp toggle_color(:black), do: :red

  # VALIDATE RED-BLACK TREE PROPERTIES
  @spec valid_red_black_tree?(t()) :: boolean()
  def valid_red_black_tree?(tree) do
    case check_properties(tree) do
      {:ok, _black_height} -> true
      {:error, _reason} -> false
    end
  end

  defp check_properties(nil), do: {:ok, 1}

  defp check_properties(%RedBlackTree{color: color, left: left, right: right} = node) do
    # Check for consecutive red nodes
    if red?(node) and (red?(left) or red?(right)) do
      {:error, :red_red_violation}
    else
      with {:ok, left_black_height} <- check_properties(left),
           {:ok, right_black_height} <- check_properties(right),
           true <- left_black_height == right_black_height do
        black_height = left_black_height + if color == :black, do: 1, else: 0
        {:ok, black_height}
      else
        {:error, reason} -> {:error, reason}
        false -> {:error, :black_height_mismatch}
      end
    end
  end
end
