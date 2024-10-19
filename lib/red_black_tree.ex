defmodule RedBlackTree do
  @moduledoc """
  Implementation of a Red-Black Tree node.
  Time complexity (hopefully):
    - insertion: O(log(N))
    - deletion: O(log(N))
    - lookup: O(log(N))
  """

  defstruct color: :black, key: nil, value: nil, left: nil, right: nil

  @type t :: %RedBlackTree{
          color: :red | :black,
          key: any,
          value: any,
          left: RedBlackTree.t() | nil,
          right: RedBlackTree.t() | nil
        }

  @spec new(any, any) :: t
  def new(key, value) do
    %RedBlackTree{
      color: :red,
      key: key,
      value: value,
      left: nil,
      right: nil
    }
  end
end
