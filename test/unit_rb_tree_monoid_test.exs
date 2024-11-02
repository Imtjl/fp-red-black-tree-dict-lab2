defmodule RedBlackTreeMonoidUnitTest do
  use ExUnit.Case
  alias RedBlackTree

  test "merging with nil (neutral element) does not change the tree" do
    tree = RedBlackTree.insert(nil, 10, "value")
    merged_left = RedBlackTree.merge(nil, tree)
    merged_right = RedBlackTree.merge(tree, nil)

    assert merged_left == tree
    assert merged_right == tree
  end

  test "associative property of merging two trees" do
    tree1 = RedBlackTree.insert(nil, 1, "one")
    tree2 = RedBlackTree.insert(nil, 2, "two")
    tree3 = RedBlackTree.insert(nil, 3, "three")

    # (tree1 + tree2) + tree3 == tree1 + (tree2 + tree3)
    merged_left = RedBlackTree.merge(RedBlackTree.merge(tree1, tree2), tree3)
    merged_right = RedBlackTree.merge(tree1, RedBlackTree.merge(tree2, tree3))

    assert merged_left == merged_right
  end
end
