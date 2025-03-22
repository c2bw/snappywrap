defmodule Snappywrap do
  @moduledoc """
  A pure Elixir library to wrap a binary as _uncompressed_ data in Snappy format.

  This library _does not_ provide compress/decompress functions, but only wraps the data
  in Snappy framing or block format that can be decompressed (decoded) by Snappy-compatible libraries.

  This library is mostly for testing and/or low performance situations where using NIFs
  such as [`snappyrex`](https://github.com/c2bw/snappyrex) is not required.
  """

  @doc """
   Wrap the data in Snappy `framing` format.
  """
  @spec wrap_framed(binary) :: {:ok, binary} | {:error, String.t()}
  def wrap_framed(data) when is_binary(data), do: data |> maybe_encode(&Snappywrap.Framing.encode/1)

  @doc """
   Wrap the data in Snappy `block` format.
  """
  @spec wrap(binary) :: {:ok, binary} | {:error, String.t()}
  def wrap(data) when is_binary(data), do: data |> maybe_encode(&Snappywrap.Block.encode/1)

  defp maybe_encode(data, encode_fn) do
    max_bytes = Snappywrap.Helper.input_max_bytes()

    data
    |> byte_size()
    |> case do
      data_bytes when data_bytes > max_bytes -> {:error, "Input exceeds the maximum allowed size of #{max_bytes} bytes"}
      _ -> {:ok, encode_fn.(data)}
    end
  end
end
