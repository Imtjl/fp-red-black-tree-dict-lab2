defmodule RedBlackTreeMonoidPropertyTest do
  use ExUnit.Case
  use ExUnitProperties
  alias RedBlackTree

  property "merging with nil (neutral element) does not change the tree" do
    check all(
            keys <- uniq_list_of(integer(), min_length: 1, max_tries: 1000),
            values <- list_of(term()),
            max_runs: 50
          ) do
      values = Enum.take(values, length(keys))
      kv_pairs = Enum.zip(keys, values)

      tree =
        Enum.reduce(kv_pairs, nil, fn {key, value}, acc ->
          RedBlackTree.insert(acc, key, value)
        end)

      assert RedBlackTree.merge(nil, tree) == tree
      assert RedBlackTree.merge(tree, nil) == tree
    end
  end

  property "associative property of merging two trees" do
    check all(
            keys1 <- uniq_list_of(integer(), min_length: 1, max_tries: 1000),
            values1 <- list_of(term(), length: length(keys1)),
            keys2 <- uniq_list_of(integer(), min_length: 1, max_tries: 1000),
            values2 <- list_of(term(), length: length(keys2)),
            keys3 <- uniq_list_of(integer(), min_length: 1, max_tries: 1000),
            values3 <- list_of(term(), length: length(keys3)),
            max_runs: 100
          ) do
      kv_pairs1 = Enum.zip(keys1, values1)
      kv_pairs2 = Enum.zip(keys2, values2)
      kv_pairs3 = Enum.zip(keys3, values3)

      tree1 = Enum.reduce(kv_pairs1, nil, fn {k, v}, acc -> RedBlackTree.insert(acc, k, v) end)
      tree2 = Enum.reduce(kv_pairs2, nil, fn {k, v}, acc -> RedBlackTree.insert(acc, k, v) end)
      tree3 = Enum.reduce(kv_pairs3, nil, fn {k, v}, acc -> RedBlackTree.insert(acc, k, v) end)

      merged_left = RedBlackTree.merge(RedBlackTree.merge(tree1, tree2), tree3)
      merged_right = RedBlackTree.merge(tree1, RedBlackTree.merge(tree2, tree3))

      assert merged_left == merged_right
    end
  end
end
