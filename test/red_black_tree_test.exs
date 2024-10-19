defmodule RedBlackTreeTest do
  use ExUnit.Case
  alias RedBlackTree

  test "insert into an empty tree" do
    tree = RedBlackTree.insert(nil, 10, "value")
    assert tree.key == 10
    assert tree.value == "value"
    assert tree.color == :black
    assert tree.left == nil
    assert tree.right == nil
  end

  test "insert multiple elements" do
    tree = nil
    tree = RedBlackTree.insert(tree, 10, "ten")
    tree = RedBlackTree.insert(tree, 5, "five")
    tree = RedBlackTree.insert(tree, 15, "fifteen")

    assert RedBlackTree.get(tree, 10) == "ten"
    assert RedBlackTree.get(tree, 5) == "five"
    assert RedBlackTree.get(tree, 15) == "fifteen"

    # Проверяем, что корень чёрный
    assert tree.color == :black
  end

  test "inserting duplicate keys updates the value" do
    tree = nil
    tree = RedBlackTree.insert(tree, 10, "initial")
    tree = RedBlackTree.insert(tree, 10, "updated")

    assert RedBlackTree.get(tree, 10) == "updated"
  end

  test "insertion maintains red-black properties" do
    # Вставляем последовательность элементов
    tree = nil
    keys = Enum.shuffle(1..100)

    tree =
      Enum.reduce(keys, tree, fn key, acc ->
        RedBlackTree.insert(acc, key, "value")
      end)

    # Проверяем, что дерево является корректным красно-чёрным деревом
    assert RedBlackTree.valid_red_black_tree?(tree)
  end
end
