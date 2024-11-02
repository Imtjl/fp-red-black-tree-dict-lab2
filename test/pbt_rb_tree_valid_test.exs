defmodule RedBlackTreePropertyBasedTest do
  use ExUnit.Case
  use ExUnitProperties

  alias RedBlackTree

  property "insertion maintains red-black properties for any sequence of integers" do
    check all(
            keys <- uniq_list_of(integer()),
            values <- list_of(term()),
            max_runs: 100
          ) do
      values = Enum.take(values, length(keys))
      kv_pairs = Enum.zip(keys, values)

      tree =
        Enum.reduce(kv_pairs, nil, fn {key, value}, acc ->
          RedBlackTree.insert(acc, key, value)
        end)

      assert tree == nil or RedBlackTree.valid_red_black_tree?(tree),
             "Should follow rb-tree properties"
    end
  end

  property "inserting and retrieving values works correctly" do
    check all(
            keys <- uniq_list_of(integer()),
            values <- list_of(term()),
            max_runs: 100
          ) do
      values = Enum.take(values, length(keys))
      kv_pairs = Enum.zip(keys, values)

      tree =
        Enum.reduce(kv_pairs, nil, fn {key, value}, acc ->
          RedBlackTree.insert(acc, key, value)
        end)

      Enum.each(kv_pairs, fn {key, value} ->
        assert RedBlackTree.get(tree, key) == value
      end)
    end
  end
end
