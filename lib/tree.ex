defmodule TREE do
  @moduledoc """
  Documentation for `TREE`.
  """

  alias TREE.NODE

  defstruct [:current, :root]

  @type element :: term()
  @type current :: (a :: element(), b :: element() -> integer())
  @type tree :: %__MODULE__{root: NODE.t() | nil, current: current()}

  @spec new([element()], current()) :: tree()
  def new(elements \\ [], current \\ fn a, b -> a - b end)
      when is_list(elements) and is_function(current) do
    tree = %__MODULE__{current: current}

    Enum.reduce(elements, tree, fn element, tree ->
      insert(tree, element)
    end)
  end

  @spec insert(tree(), element(), (element(), element() -> element())) :: tree()
  def insert(%__MODULE__{} = tree, element, fun \\ fn _a, b -> b end) do
    %__MODULE__{tree | root: insert_node(tree.root, element, tree.current, fun)}
  end

  defp insert_node(nil, element, _current, _fun), do: %NODE{value: element}

  defp insert_node(%NODE{left: left, value: elem1, right: right} = node, elem2, current, fun) do
    case compare(elem2, elem1, current) do
      :eq -> %NODE{node | value: fun.(elem1, elem2)}
      :lt -> %NODE{node | left: insert_node(left, elem2, current, fun)}
      :gt -> %NODE{node | right: insert_node(right, elem2, current, fun)}
    end
  end

  defp compare(a, b, current) do
    val = current.(a, b)

    cond do
      val == 0 -> :eq
      val < 0 -> :lt
      val > 0 -> :gt
    end
  end

end

tree = TREE.new([0])
tree = TREE.insert(tree, 2)
tree.root
