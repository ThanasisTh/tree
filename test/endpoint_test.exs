defmodule TREE.EndpointTest do
  use ExUnit.Case, async: true
  use Plug.Test

  require Logger
  # doctest TREE

  @opts TREE.Endpoint.init([])

  test "it returns pong" do
    # Create a test connection
    conn = conn(:get, "/ping")

    # Invoke the plug
    conn = TREE.Endpoint.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "pong!"
  end

  test "it returns 200 with a valid payload" do
    # Create a test connection
    conn = conn(:post, "/events", %{events: [%{}, %{}]} )

    # Invoke the plug
    conn = TREE.Endpoint.call(conn, @opts)

    # Assert the response
    assert conn.status == 200
  end

  test "it returns 422 with an invalid payload" do
    # Create a test connection
    conn = conn(:post, "/events", %{})

    # Invoke the plug
    conn = TREE.Endpoint.call(conn, @opts)

    # Assert the response
    assert conn.status == 422
  end

  test "it returns 404 when no route matches" do
    # Create a test connection
    conn = conn(:get, "/fail")

    # Invoke the plug
    conn = TREE.Endpoint.call(conn, @opts)

    # Assert the response
    assert conn.status == 404
  end

  test "it creates a new tree" do
    # Create a test connection
    conn = conn(:post, "/insert", %{value: [3], tree: nil} )

    # Invoke the plug
    conn = TREE.Endpoint.call(conn, @opts)

    # Assert the response
    assert conn.status == 200
    assert conn.resp_body == Poison.encode!(%{"tree" => %TREE.NODE{left: nil, value: 3, right: nil}})
  end

  test "it inserts elements" do
    # Create a test connection
    conn = conn(:post, "/insert", %{value: 2, tree: TREE.new([3], fn a, b -> a <= b end)} )

    # Invoke the plug
    conn = TREE.Endpoint.call(conn, @opts)

    # Assert the response
    assert conn.status == 200
    assert conn.resp_body == Poison.encode!(%{"tree" => %TREE.NODE{left: nil, right: %TREE.NODE{left: nil, right: nil, value: 2}, value: 3}})
  end

end
