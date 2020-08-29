defmodule TREE.NODE do
  defstruct [:left, :value, :right]

  @typedoc "Represents node struct."
  @type t :: %__MODULE__{
          left: t() | nil,
          value: TREE.element(),
          right: t() | nil
        }
end
