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
end
