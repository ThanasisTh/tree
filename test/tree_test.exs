defmodule TREETest do
  use ExUnit.Case
  doctest TREE

  alias TREE.NODE

  describe "new/2" do
    test "creates an empty tree when given an empty list and comparator" do
      assert %TREE{root: nil} = TREE.new([], fn a, b -> a <= b end)
    end

    test "creates a tree with a root node when given one element" do
      assert %TREE{root: %NODE{left: nil, value: 0, right: nil}} = TREE.new([0])
    end

    test "creates a tree with branches when given multiple elements" do
      assert %TREE{
               root: %NODE{left: nil, value: 0, right: %NODE{left: nil, value: 1, right: nil}}
             } = TREE.new([0, 1])
    end
  end

  describe "insert/3" do
    test "inserts a lower value on the left" do
      tree = TREE.insert(TREE.new([0]), -1)

      assert tree.root.value == 0
      assert tree.root.left.value == -1
    end

    test "inserts a higher value on the right" do
      tree = TREE.insert(TREE.new([0]), 1)

      assert tree.root.value == 0
      assert tree.root.right.value == 1
    end

    test "inserts multiple branches" do
      tree =
        TREE.new([0])
        |> TREE.insert(-2)
        |> TREE.insert(2)
        |> TREE.insert(-3)
        |> TREE.insert(-1)
        |> TREE.insert(3)
        |> TREE.insert(1)

      assert tree.root.value == 0
      assert tree.root.left.value == -2
      assert tree.root.left.left.value == -3
      assert tree.root.left.right.value == -1
      assert tree.root.right.value == 2
      assert tree.root.right.left.value == 1
      assert tree.root.right.right.value == 3
    end
  end
end
