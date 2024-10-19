defmodule TreeDict do
  @moduledoc """
  Dictionary, implemented using Red-Black Tree
  """

  defstruct tree: nil

  @type t :: %TreeDict{tree: RedBlackTree.t() | nil}

  @spec new() :: t()
  def new do
    %TreeDict{}
  end

  @spec insert(t(), any(), any()) :: t()
  def insert(%TreeDict{tree: tree} = dict, key, value) do
    new_tree = RedBlackTree.insert(tree, key, value)
    %TreeDict{dict | tree: new_tree}
  end

  @spec get(t(), any()) :: any() | nil
  def get(%TreeDict{tree: tree}, key) do
    RedBlackTree.get(tree, key)
  end

  @spec delete(t(), any()) :: t()
  def delete(%TreeDict{tree: tree} = dict, key) do
    new_tree = RedBlackTree.delete(tree, key)
    %TreeDict{dict | tree: new_tree}
  end

  @spec filter(t(), (any(), any() -> boolean())) :: t()
  def filter(%TreeDict{tree: tree}, func) do
    %TreeDict{tree: RedBlackTree.filter(tree, func)}
  end

  @spec map(t(), (any(), any() -> any())) :: t()
  def map(%TreeDict{tree: tree}, func) do
    %TreeDict{tree: RedBlackTree.map(tree, func)}
  end

  @spec foldl(t(), acc :: any(), (any(), any(), acc :: any() -> any())) :: any()
  def foldl(%TreeDict{tree: tree}, acc, func) do
    RedBlackTree.foldl(tree, acc, func)
  end

  @spec foldr(t(), acc :: any(), (any(), any(), acc :: any() -> any())) :: any()
  def foldr(%TreeDict{tree: tree}, acc, func) do
    RedBlackTree.foldr(tree, acc, func)
  end

  @spec merge(t(), t()) :: t()
  def merge(%TreeDict{tree: tree1}, %TreeDict{tree: tree2}) do
    %TreeDict{tree: RedBlackTree.merge(tree1, tree2)}
  end
end
