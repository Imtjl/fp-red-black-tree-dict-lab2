defmodule RedBlackTreeUnitTest do
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

  test "delete from empty tree returns nil" do
    tree = nil
    assert RedBlackTree.delete(tree, 10) == nil
  end

  test "delete non-existing key does not change tree" do
    tree = RedBlackTree.insert(nil, 10, "value")
    tree_after_delete = RedBlackTree.delete(tree, 20)
    assert tree == tree_after_delete
  end

  test "delete leaf node" do
    tree = nil
    tree = RedBlackTree.insert(tree, 10, "value")
    tree = RedBlackTree.insert(tree, 5, "value5")
    tree = RedBlackTree.insert(tree, 15, "value15")

    tree = RedBlackTree.delete(tree, 5)
    assert RedBlackTree.get(tree, 5) == nil
    assert RedBlackTree.valid_red_black_tree?(tree)
  end

  test "delete node with one child" do
    tree = nil
    tree = RedBlackTree.insert(tree, 10, "value")
    tree = RedBlackTree.insert(tree, 5, "value5")
    tree = RedBlackTree.insert(tree, 3, "value3")

    tree = RedBlackTree.delete(tree, 5)
    assert RedBlackTree.get(tree, 5) == nil
    assert RedBlackTree.get(tree, 3) == "value3"
    assert RedBlackTree.valid_red_black_tree?(tree)
  end

  test "delete node with two children" do
    tree = nil
    tree = RedBlackTree.insert(tree, 10, "value")
    tree = RedBlackTree.insert(tree, 5, "value5")
    tree = RedBlackTree.insert(tree, 15, "value15")
    tree = RedBlackTree.insert(tree, 12, "value12")
    tree = RedBlackTree.insert(tree, 18, "value18")

    tree = RedBlackTree.delete(tree, 15)
    assert RedBlackTree.get(tree, 15) == nil
    assert RedBlackTree.get(tree, 12) == "value12"
    assert RedBlackTree.get(tree, 18) == "value18"
    assert RedBlackTree.valid_red_black_tree?(tree)
  end

  test "delete root node" do
    tree = nil
    tree = RedBlackTree.insert(tree, 10, "value")
    tree = RedBlackTree.insert(tree, 5, "value5")
    tree = RedBlackTree.insert(tree, 15, "value15")

    tree = RedBlackTree.delete(tree, 10)
    assert RedBlackTree.get(tree, 10) == nil
    assert RedBlackTree.get(tree, 5) == "value5"
    assert RedBlackTree.get(tree, 15) == "value15"
    assert RedBlackTree.valid_red_black_tree?(tree)
  end

  test "delete multiple nodes" do
    tree = nil
    keys = Enum.shuffle(1..20)
    tree = Enum.reduce(keys, tree, fn key, acc -> RedBlackTree.insert(acc, key, "value") end)

    keys_to_delete = Enum.shuffle(5..15)
    tree = Enum.reduce(keys_to_delete, tree, fn key, acc -> RedBlackTree.delete(acc, key) end)

    Enum.each(keys_to_delete, fn key ->
      assert RedBlackTree.get(tree, key) == nil
    end)

    remaining_keys = Enum.filter(1..20, fn key -> not Enum.member?(keys_to_delete, key) end)

    Enum.each(remaining_keys, fn key ->
      assert RedBlackTree.get(tree, key) == "value"
    end)

    assert RedBlackTree.valid_red_black_tree?(tree)
  end
end
