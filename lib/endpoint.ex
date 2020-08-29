defmodule TREE.Endpoint do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug :dispatch

  get "/hello" do
    send_resp(conn, 200, "world!!")
  end

  get "/ping" do
    send_resp(conn, 200, "pong!")
  end

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

  defp missing_events do
    Poison.encode!(%{error: "Expected Payload: { 'events': [...] }"})
  end






  match _ do
    send_resp(conn, 404, "oops")
  end
end
