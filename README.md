# TREE [![Build Status](https://travis-ci.com/ThanasisTh/tree.svg?token=p2Tydfti7qXzfY1VPiTq&branch=master)](https://travis-ci.com/ThanasisTh/tree)

Elixir implementation of a basic binary tree with the insert operation, as well as a basic REST API using plug + tests. 

The application is not dockerized. After downloading, it can be run locally by executing  
```shell 
mix run --no-halt 
```
 from inside the mix project. The API can be used with Postman.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tree` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tree, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/tree](https://hexdocs.pm/tree).

