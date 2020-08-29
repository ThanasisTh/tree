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

  match _ do
    send_resp(conn, 404, "oops")
  end
end
