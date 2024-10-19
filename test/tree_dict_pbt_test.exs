defmodule TreeDictPropertyBasedTest do
  use ExUnit.Case
  use ExUnitProperties

  alias TreeDict

  property "TreeDict insert and get work correctly" do
    check all(
            keys <- uniq_list_of(term()),
            values <- list_of(term()),
            max_runs: 100
          ) do
      values = Enum.take(values, length(keys))
      kv_pairs = Enum.zip(keys, values)

      dict =
        Enum.reduce(kv_pairs, TreeDict.new(), fn {key, value}, acc ->
          TreeDict.insert(acc, key, value)
        end)

      Enum.each(kv_pairs, fn {key, value} ->
        assert TreeDict.get(dict, key) == value
      end)
    end
  end
end
