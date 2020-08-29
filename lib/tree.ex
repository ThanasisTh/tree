defmodule TREE do
  @moduledoc """
  Basic binary tree with insert operation.
  """

  alias TREE.NODE

  defstruct [:compare, :root]

  @typedoc "value stored in a node."
  @type element :: term()

  @typedoc "Checks whether current node should be stored in right or left subtree (comparing function)."
  @type compare :: (a :: element(), b :: element() -> integer())

  @typedoc "Tree."
  @type tree :: %__MODULE__{root: NODE.t() | nil, compare: compare()}

  @doc """
  Creates new tree

  ## Parameters

    - elements: List of value to be stored in tree.
    - compare: Comparing function

  ## Examples

      iex> tree = TREE.new([0])
      iex> tree.root
      %TREE.NODE{left: nil, value: 0, right: nil}

      iex> tree = TREE.new([0, 1])
      iex> tree.root
      %TREE.NODE{left: nil, value: 0, right: %TREE.NODE{left: nil, value: 1, right: nil}}
  """
  @spec new([element()], compare()) :: tree()
  def new(elements \\ [], compare \\ fn a, b -> a - b end)
      when is_list(elements) and is_function(compare) do
    tree = %__MODULE__{compare: compare}

    Enum.reduce(elements, tree, fn element, tree ->
      insert(tree, element)
    end)
  end


  @doc """
  Adds a node to a tree.

  Conflicts with old nodes resolved by comparing and replacing.
  Defaults to replacing with new element.

  ## Examples
      iex> tree = TREE.new([1])
      iex> tree = TREE.insert(tree, 2)
      iex> tree.root
      %TREE.NODE{left: nil, value: 1, right: %TREE.NODE{value: 2, left: nil, right: nil}}
  """
  @spec insert(tree(), element(), (element(), element() -> element())) :: tree()
  def insert(%__MODULE__{} = tree, element, fun \\ fn _a, b -> b end) do
    %__MODULE__{tree | root: insert_node(tree.root, element, tree.compare, fun)}
  end

  defp insert_node(nil, element, _compare, _fun), do: %NODE{value: element}

  defp insert_node(%NODE{left: left, value: elem1, right: right} = node, elem2, compare, fun) do
    case compare(elem2, elem1, compare) do
      :eq -> %NODE{node | value: fun.(elem1, elem2)}
      :lt -> %NODE{node | left: insert_node(left, elem2, compare, fun)}
      :gt -> %NODE{node | right: insert_node(right, elem2, compare, fun)}
    end
  end


  defp compare(a, b, compare) do
    val = compare.(a, b)

    cond do
      val == 0 -> :eq
      val < 0 -> :lt
      val > 0 -> :gt
    end
  end

end
