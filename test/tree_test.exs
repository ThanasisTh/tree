defmodule TREETest do
  use ExUnit.Case
  doctest TREE

  test "greets the world" do
    assert TREE.hello() == :world
  end
end
