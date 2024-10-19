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

  # def insert(%TreeDict{tree: tree} = dict, key, value) do
  #   %TreeDict{tree: insert_into_tree(tree, key, value)}
  # end

  # filter, mapping, folding
  # def filter(dict, func) do
  #   %TreeDict{tree: RedBlackTree.filter(dict.tree, func)}
  # end
  #
  # def map(dict, func) do
  #   %TreeDict{tree: RedBlackTree.map(dict.tree, func)}
  # end
  #
  # def foldl(dict, acc, func) do
  #   RedBlackTree.foldl(dict.tree, acc, func)
  # end
  #
  # def foldr(dict, acc, func) do
  #   RedBlackTree.foldr(dict.tree, acc, func)
  # end
end
