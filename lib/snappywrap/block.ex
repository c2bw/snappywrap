defmodule Snappywrap.Block do
  @moduledoc """
  Store uncompressed data in Snappy block format.

  In this wrapper implementation, each block can only be an uncompressed (literal) data block.

  Snappy output has the following format:
  - `preamble` - `varint block size`
  - `stream`: composed `of` only `literals` in this wrapper implementation


  1. Preamble
  The stream starts with the uncompressed length (up to a maximum of 2^32 - 1),
  stored as a little-endian varint. Varints consist of a series of bytes,
  where the lower 7 bits are data and the upper bit is set iff there are
  more bytes to be read. In other words, an uncompressed length of 64 would
  be stored as 0x40, and an uncompressed length of 2097150 (0x1FFFFE)
  would be stored as 0xFE 0xFF 0x7F.

  2. Compressed stream of Literals (00)
  Literals are uncompressed data stored directly in the byte stream.
  The literal length is stored differently depending on the length
  of the literal:

  - For literals up to and including 60 bytes in length, the upper
   six bits of the tag byte contain (len-1). The literal follows
   immediately thereafter in the bytestream.
  - For longer literals, the (len-1) value is stored after the tag byte,
   little-endian. The upper six bits of the tag byte describe how
   many bytes are used for the length; 60, 61, 62 or 63 for
   1-4 bytes, respectively. The literal itself follows after the
   length.
  """

  # Set the maximum literal length to 65536 bytes (Snappy does not specify a maximum literal length)
  @max_literal_length 65536

  @doc """
    Encodes as _uncompressed_ data in Snappy `block` format.

    Input data size is assumed to be valid.
  """
  def encode(data) when is_binary(data), do: data |> encode_data()

  # Private functions

  defp encode_data(data) when is_binary(data) do
    preamble = byte_size(data) |> Varint.LEB128.encode()
    literals = data |> to_binary_literals()
    <<preamble::binary, literals::binary>>
  end

  defp to_binary_literals(data) do
    data
    |> Snappywrap.Helper.chunk_binary(@max_literal_length)
    |> Enum.map(fn chunk -> build_literal(chunk) end)
    |> Enum.join()
  end

  defp build_literal(data) do
    len_header = literal_length_header(byte_size(data))
    <<len_header::binary, data::binary>>
  end

  defp literal_length_header(len) when len <= 60, do: <<len - 1::6, 0::2>>

  defp literal_length_header(length) when is_integer(length) and length > 0 do
    min_bytes = min_bytes(length)
    length_bytes = <<59 + min_bytes::6>>
    <<length_bytes::bitstring, 0::2, length - 1::unsigned-integer-size(min_bytes * 8)-little>>
  end

  defp min_bytes(n) when n > 0 do
    bits = :math.log2(n + 1) |> Float.ceil() |> trunc()
    div(bits + 7, 8)
  end
end
