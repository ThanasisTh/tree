defmodule TREE.Endpoint do
  use Plug.Router
  require Logger

  plug Plug.Logger
  plug :match
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug :dispatch

  # --------------------------- TEST ENDPOINTS ----------------------------
  # Handle incoming events, if the payload is the right shape, process the
  # events, otherwise return an error.
  post "/events" do
    {status, body} =
      case conn.body_params do
        %{"events" => events} -> {200, process_events(events)}
        _ -> {422, missing_events()}
      end

    send_resp(conn, status, body)
  end

  defp process_events(events) when is_list(events) do
    # Do some processing on a list of events
    Poison.encode!(%{response: "Received Events!"})
  end

  defp process_events(_) do
    # If we can't process anything, let them know :)
    Poison.encode!(%{response: "Please Send Some Events!"})
  end

  get "/ping" do
    send_resp(conn, 200, "pong!")
  end
  #----------------------------------------------------------------------------




  # ---------------------------- USED ENDPOINTS -------------------------------
  defp missing_events do
    Poison.encode!(%{error: "Expected Payload: { 'events': [...] }"})
  end

  # post "/new_tree" do
  #   {status, body} =
  #     case conn.body_params do
  #       %{"elements" => elements} -> {200, create_tree(elements)}
  #       _ -> {422, missing_events()}
  #     end

  #   send_resp(conn |> put_resp_content_type("application/json"), status, body)
  # end

  post "/insert" do
    {status, body} =
      case conn.body_params do
        %{"value" => elements, "tree" => nil} -> {200, create_tree(elements)}
        %{"value" => elements, "tree" => tree} -> {200, insert_elements(tree, elements)}
        _ -> {422, missing_events()}
      end

    send_resp(conn, status, body)
  end

  defp create_tree(elements) do
    # Use given elements to initialize a tree.
    tree = TREE.new(elements, fn a, b -> a <= b end)
    response = %{"tree" => tree.root}
    Poison.encode!(response)
  end

  defp insert_elements(tree, elements) do
    # Insert given elements to given tree.
    tree = TREE.insert(tree, elements)
    response = %{"tree" => tree.root}
    Poison.encode!(response)
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
