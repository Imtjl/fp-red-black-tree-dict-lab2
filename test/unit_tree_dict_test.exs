defmodule TreeDictTest do
  use ExUnit.Case
  alias TreeDict

  test "creating a new TreeDict" do
    dict = TreeDict.new()
    assert dict.tree == nil
  end

  test "inserting and getting values" do
    dict = TreeDict.new()
    dict = TreeDict.insert(dict, :key1, "value1")
    dict = TreeDict.insert(dict, :key2, "value2")
    dict = TreeDict.insert(dict, :key3, "value3")

    assert TreeDict.get(dict, :key1) == "value1"
    assert TreeDict.get(dict, :key2) == "value2"
    assert TreeDict.get(dict, :key3) == "value3"
  end

  test "updating existing keys" do
    dict = TreeDict.new()
    dict = TreeDict.insert(dict, :key, "initial value")
    dict = TreeDict.insert(dict, :key, "updated value")

    assert TreeDict.get(dict, :key) == "updated value"
  end

  test "getting a non-existent key returns nil" do
    dict = TreeDict.new()
    dict = TreeDict.insert(dict, :existing_key, "value")

    assert TreeDict.get(dict, :nonexistent_key) == nil
  end

  test "inserting different types of keys and values" do
    dict = TreeDict.new()
    dict = TreeDict.insert(dict, "string_key", :atom_value)
    dict = TreeDict.insert(dict, 42, [1, 2, 3])
    dict = TreeDict.insert(dict, {:tuple, :key}, %{map: "value"})

    assert TreeDict.get(dict, "string_key") == :atom_value
    assert TreeDict.get(dict, 42) == [1, 2, 3]
    assert TreeDict.get(dict, {:tuple, :key}) == %{map: "value"}
  end

  test "handling nil keys and values" do
    dict = TreeDict.new()
    dict = TreeDict.insert(dict, nil, nil)

    assert TreeDict.get(dict, nil) == nil
  end

  test "inserting keys with mixed types and ensuring order is maintained" do
    dict = TreeDict.new()
    dict = TreeDict.insert(dict, 5, "five")
    dict = TreeDict.insert(dict, :atom_key, "atom")
    dict = TreeDict.insert(dict, "string_key", "string")
    dict = TreeDict.insert(dict, 3.14, "pi")

    assert TreeDict.get(dict, 5) == "five"
    assert TreeDict.get(dict, :atom_key) == "atom"
    assert TreeDict.get(dict, "string_key") == "string"
    assert TreeDict.get(dict, 3.14) == "pi"
  end

  test "inserting duplicate keys with different types" do
    dict = TreeDict.new()
    dict = TreeDict.insert(dict, "1", "string one")
    dict = TreeDict.insert(dict, 1, "integer one")
    dict = TreeDict.insert(dict, :one, "atom one")

    assert TreeDict.get(dict, "1") == "string one"
    assert TreeDict.get(dict, 1) == "integer one"
    assert TreeDict.get(dict, :one) == "atom one"
  end

  test "inserting a large number of elements" do
    dict = TreeDict.new()

    dict =
      Enum.reduce(1..1000, dict, fn i, acc ->
        TreeDict.insert(acc, i, "value #{i}")
      end)

    Enum.each(1..1000, fn i ->
      assert TreeDict.get(dict, i) == "value #{i}"
    end)
  end

  test "delete from empty dictionary" do
    dict = TreeDict.new()
    dict = TreeDict.delete(dict, :key)
    assert TreeDict.get(dict, :key) == nil
  end

  test "insert and delete keys" do
    dict = TreeDict.new()
    dict = TreeDict.insert(dict, :a, 1)
    dict = TreeDict.insert(dict, :b, 2)
    dict = TreeDict.insert(dict, :c, 3)

    dict = TreeDict.delete(dict, :b)
    assert TreeDict.get(dict, :b) == nil
    assert TreeDict.get(dict, :a) == 1
    assert TreeDict.get(dict, :c) == 3
  end

  test "delete non-existing key" do
    dict = TreeDict.new()
    dict = TreeDict.insert(dict, :a, 1)
    dict = TreeDict.delete(dict, :b)
    assert TreeDict.get(dict, :a) == 1
  end

  test "delete all keys" do
    dict = TreeDict.new()
    dict = TreeDict.insert(dict, :a, 1)
    dict = TreeDict.insert(dict, :b, 2)
    dict = TreeDict.insert(dict, :c, 3)

    dict = TreeDict.delete(dict, :a)
    dict = TreeDict.delete(dict, :b)
    dict = TreeDict.delete(dict, :c)

    assert TreeDict.get(dict, :a) == nil
    assert TreeDict.get(dict, :b) == nil
    assert TreeDict.get(dict, :c) == nil
  end

  test "filtering keys based on value" do
    dict = TreeDict.new()
    dict = TreeDict.insert(dict, :key1, 10)
    dict = TreeDict.insert(dict, :key2, 20)
    dict = TreeDict.insert(dict, :key3, 30)

    filtered_dict = TreeDict.filter(dict, fn _key, value -> value > 15 end)

    assert TreeDict.get(filtered_dict, :key1) == nil
    assert TreeDict.get(filtered_dict, :key2) == 20
    assert TreeDict.get(filtered_dict, :key3) == 30
  end

  # Тесты на отображение (map)
  test "applying map function to all values" do
    dict = TreeDict.new()
    dict = TreeDict.insert(dict, :key1, 10)
    dict = TreeDict.insert(dict, :key2, 20)
    dict = TreeDict.insert(dict, :key3, 30)

    mapped_dict = TreeDict.map(dict, fn _key, value -> value * 2 end)

    assert TreeDict.get(mapped_dict, :key1) == 20
    assert TreeDict.get(mapped_dict, :key2) == 40
    assert TreeDict.get(mapped_dict, :key3) == 60
  end

  # Тесты на свёртки (левая и правая)
  test "left fold applies function from left to right" do
    dict = TreeDict.new()
    dict = TreeDict.insert(dict, 1, 2)
    dict = TreeDict.insert(dict, 3, 4)
    dict = TreeDict.insert(dict, 5, 6)

    result = TreeDict.foldl(dict, 0, fn _key, value, acc -> acc + value end)
    assert result == 12
  end

  test "right fold applies function from right to left" do
    dict = TreeDict.new()
    dict = TreeDict.insert(dict, 1, 2)
    dict = TreeDict.insert(dict, 3, 4)
    dict = TreeDict.insert(dict, 5, 6)

    result = TreeDict.foldr(dict, 0, fn _key, value, acc -> acc + value end)
    assert result == 12
  end

  # Check monoid properties
  test "monoid property: merging with empty TreeDict" do
    dict1 = TreeDict.new()
    dict2 = TreeDict.insert(TreeDict.new(), :key, "value")

    merged_left = TreeDict.merge(dict1, dict2)
    merged_right = TreeDict.merge(dict2, dict1)

    assert merged_left == dict2
    assert merged_right == dict2
  end

  test "monoid property: associative merging" do
    dict1 = TreeDict.insert(TreeDict.new(), :key1, "value1")
    dict2 = TreeDict.insert(TreeDict.new(), :key2, "value2")
    dict3 = TreeDict.insert(TreeDict.new(), :key3, "value3")

    merged_left = TreeDict.merge(TreeDict.merge(dict1, dict2), dict3)
    merged_right = TreeDict.merge(dict1, TreeDict.merge(dict2, dict3))

    assert merged_left == merged_right
  end
end
