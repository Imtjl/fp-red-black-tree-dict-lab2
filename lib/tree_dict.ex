defmodule TreeDict do
  @moduledoc """
  Documentation for `TreeDict`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> TreeDict.hello()
      :world

  """
  def hello do
    :world
  end

  defstruct tree: nil

  def new, do: %TreeDict{}
end
