defmodule TreeDictTreePropertyBasedTest do
  use ExUnit.Case
  use ExUnitProperties

  alias RedBlackTree

  property "insert and get values correctly" do
    check all(key <- term(), value <- term()) do
      dict = TreeDict.new() |> TreeDict.insert(key, value)
      assert TreeDict.get(dict, key) == value
    end
  end

  property "deleting a key removes it from the dictionary" do
    check all(key <- term(), value <- term()) do
      dict = TreeDict.new() |> TreeDict.insert(key, value) |> TreeDict.delete(key)
      assert TreeDict.get(dict, key) == nil
    end
  end

  property "merging two dictionaries maintains values" do
    check all(
            keys1 <- uniq_list_of(integer(), min_length: 1),
            keys2 <- uniq_list_of(integer(), min_length: 1),
            values1 <- list_of(term(), length: length(keys1)),
            values2 <- list_of(term(), length: length(keys2))
          ) do
      dict1 =
        Enum.zip(keys1, values1)
        |> Enum.reduce(TreeDict.new(), fn {k, v}, acc -> TreeDict.insert(acc, k, v) end)

      dict2 =
        Enum.zip(keys2, values2)
        |> Enum.reduce(TreeDict.new(), fn {k, v}, acc -> TreeDict.insert(acc, k, v) end)

      merged_dict = TreeDict.merge(dict1, dict2)

      Enum.each(keys1, fn k ->
        if k in keys2 do
          assert TreeDict.get(merged_dict, k) != nil
        else
          assert TreeDict.get(merged_dict, k) == TreeDict.get(dict1, k)
        end
      end)
    end
  end
end
