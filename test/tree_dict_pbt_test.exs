# defmodule TreeDictPropertyBasedTest do
#   use ExUnit.Case
#   use ExUnitProperties
#
#   alias RedBlackTree
#   alias TreeDict
#
#   property "red-black tree is a monoid" do
#     check all(
#             keys1 <- uniq_list_of(integer()),
#             values1 <- list_of(term()),
#             keys2 <- uniq_list_of(integer()),
#             values2 <- list_of(term()),
#             max_runs: 100
#           ) do
#       values1 = Enum.take(values1, length(keys1))
#       values2 = Enum.take(values2, length(keys2))
#
#       tree1 = create_tree(keys1, values1)
#       tree2 = create_tree(keys2, values2)
#
#       merged_tree1 = RedBlackTree.merge(tree1, tree2)
#       merged_tree2 = RedBlackTree.merge(tree2, tree1)
#
#       # Ensure both merged trees are valid red-black trees
#       assert RedBlackTree.valid_red_black_tree?(merged_tree1)
#       assert RedBlackTree.valid_red_black_tree?(merged_tree2)
#
#       # Ensure both merged trees contain the same entries
#       assert entries(merged_tree1) == entries(merged_tree2)
#     end
#   end
#
#   property "red-black tree handles multiple types (polymorphic)" do
#     check all(
#             keys <- uniq_list_of(one_of([integer(), atom(:alphanumeric), string(:ascii)])),
#             values <- list_of(term()),
#             max_runs: 100
#           ) do
#       values = Enum.take(values, length(keys))
#
#       tree = create_tree(keys, values)
#
#       assert RedBlackTree.valid_red_black_tree?(tree)
#     end
#   end
#
#   property "TreeDict insert and get work correctly" do
#     check all(
#             keys <- uniq_list_of(term()),
#             values <- list_of(term()),
#             max_runs: 100
#           ) do
#       values = Enum.take(values, length(keys))
#       kv_pairs = Enum.zip(keys, values)
#
#       dict =
#         Enum.reduce(kv_pairs, TreeDict.new(), fn {key, value}, acc ->
#           TreeDict.insert(acc, key, value)
#         end)
#
#       Enum.each(kv_pairs, fn {key, value} ->
#         assert TreeDict.get(dict, key) == value
#       end)
#     end
#   end
#
#   # Вспомогательные функции
#
#   defp create_tree([], _values), do: nil
#
#   defp create_tree(keys, values) do
#     Enum.reduce(Enum.zip(keys, values), nil, fn {key, value}, acc ->
#       RedBlackTree.insert(acc, key, value)
#     end)
#   end
#
#   defp entries(nil), do: []
#
#   defp entries(tree) do
#     RedBlackTree.foldl(tree, [], fn key, value, acc ->
#       [{key, value} | acc]
#     end)
#   end
# end
