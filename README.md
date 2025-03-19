# Snappywrap [![Hex Version](https://img.shields.io/hexpm/v/snappywrap.svg)](https://hex.pm/packages/snappywrap) [![Hex Docs](https://img.shields.io/badge/docs-hexpm-blue.svg)](https://hexdocs.pm/snappywrap/)

A pure Elixir library to wrap a binary as _uncompressed_ data in Snappy format.

This library _does not_ provide compress/decompress functions, but only wraps the data
in Snappy framing or block format that can be decompressed (decoded) by Snappy-compatible libraries.

This library is mostly for testing and/or low performance situations where using NIFs
such as [`snappyrex`](https://github.com/c2bw/snappyrex) is not required.

## Installation

The package can be installed by adding `snappywrap` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:snappywrap, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
iex> Snappywrap.wrap("Hello, world!")
{:ok, "\r0Hello, world!"}
iex> Snappywrap.wrap_framed("Hello, world!")
{:ok, <<255, 6, 0, 0, 115, 78, 97, 80, 112, 89, 1, 17, 0, 0, 26, 124, 78, 176, 72, 101, 108, 108, 111, 44, 32, 119, 111, 114, 108, 100, 33>>}
```

