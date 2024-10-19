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

  # ОПЕРАЦИЯ ПОИСКА !!!
  @spec get(t() | nil, any()) :: any() | nil
  def get(nil, _key), do: nil

  def get(%RedBlackTree{key: k, value: v, left: left, right: right}, key) do
    cond do
      key == k -> v
      key < k -> get(left, key)
      true -> get(right, key)
    end
  end

  # ОПЕРАЦИЯ ВСТАВКА !!!
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

        key > k ->
          %RedBlackTree{node | right: do_insert(node.right, key, value)}
      end

    balance(node)
  end

  defp ensure_black_root(%RedBlackTree{color: :red} = tree) do
    %RedBlackTree{tree | color: :black}
  end

  defp ensure_black_root(tree), do: tree

  defp rotate_left(%RedBlackTree{right: right} = h) do
    h = %RedBlackTree{h | right: right.left}

    %RedBlackTree{
      color: h.color,
      key: right.key,
      value: right.value,
      left: %RedBlackTree{h | color: :red},
      right: right.right
    }
  end

  defp rotate_right(%RedBlackTree{left: left} = h) do
    h = %RedBlackTree{h | left: left.right}

    %RedBlackTree{
      color: h.color,
      key: left.key,
      value: left.value,
      left: left.left,
      right: %RedBlackTree{h | color: :red}
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
    node = if red?(node.right), do: rotate_left(node), else: node
    node = if red?(node.left) and red?(node.left.left), do: rotate_right(node), else: node
    node = if red?(node.left) and red?(node.right), do: flip_colors(node), else: node
    node
  end

  # Вспомогательные функции
  defp red?(%RedBlackTree{color: :red}), do: true
  defp red?(_), do: false

  defp recolor(nil), do: nil

  defp recolor(%RedBlackTree{color: color} = node) do
    %RedBlackTree{node | color: toggle_color(color)}
  end

  defp toggle_color(:red), do: :black
  defp toggle_color(:black), do: :red

  # ПРОВЕРЯЕМ ДЕРЕВО НА КОРРЕКТНОСТЬ
  @spec valid_red_black_tree?(t()) :: boolean()
  def valid_red_black_tree?(tree) do
    case check_properties(tree) do
      {:ok, _black_height} -> true
      {:error, _reason} -> false
    end
  end

  defp check_properties(nil), do: {:ok, 1}

  defp check_properties(%RedBlackTree{color: color, left: left, right: right} = node) do
    # Проверяем отсутствие последовательных красных узлов
    if red?(node) and (red?(left) or red?(right)) do
      {:error, :red_red_violation}
    else
      # Рекурсивно проверяем левое и правое поддеревья
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
