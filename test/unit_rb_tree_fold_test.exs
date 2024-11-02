defmodule RedBlackTreeFoldTest do
  use ExUnit.Case
  alias RedBlackTree

  test "left fold processes nodes in order" do
    tree = RedBlackTree.insert(nil, 3, "three")
    tree = RedBlackTree.insert(tree, 1, "one")
    tree = RedBlackTree.insert(tree, 2, "two")
    # after this, the tree should look like this:
    #
    #    2
    #   / \
    #  1   3
    #

    result = RedBlackTree.foldl(tree, [], fn k, v, acc -> [{k, v} | acc] end)
    # folding should be 1, 2, 3,
    # BUT we prepend each element in accumulator:
    # [{k, v} | acc] - it results in reverse-ordering
    expected = [{3, "three"}, {2, "two"}, {1, "one"}]

    assert result == expected
  end

  test "right fold processes nodes in reverse order" do
    tree = RedBlackTree.insert(nil, 3, "three")
    tree = RedBlackTree.insert(tree, 1, "one")
    tree = RedBlackTree.insert(tree, 2, "two")
    # after this, the tree should look like this:
    #
    #    2
    #   / \
    #  1   3
    #

    result = RedBlackTree.foldr(tree, [], fn k, v, acc -> [{k, v} | acc] end)
    # folding should be 1, 2, 3,
    # BUT we prepend each element in accumulator:
    # [{k, v} | acc] - it results in reverse-ordering
    expected = [{1, "one"}, {2, "two"}, {3, "three"}]

    assert result == expected
  end
end
