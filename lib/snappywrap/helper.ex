defmodule Snappywrap.Helper do
  import Bitwise
  @moduledoc false

  @doc """
   Maximum allowed size of input data in bytes.
  """
  @spec input_max_bytes() :: non_neg_integer()
  def input_max_bytes(), do: Integer.pow(2, 32) - 1

  @doc """
  Calculates CRC-32C checksum for a Snappy chunk.

  In Snappy, checksums are not stored directly, but masked, as checksumming data and
  then its own checksum can be problematic. The masking is the same as used
  in Apache Hadoop: Rotate the checksum by 15 bits, then add the constant
  0xa282ead8 (using wraparound as normal for unsigned integers).

  This is equivalent to the following C code:

  `
  uint32_t mask_checksum(uint32_t x) {
    return ((x >> 15) | (x << 17)) + 0xa282ead8;
  }
  `

  Note that the masking is reversible.
  """
  def crc(data) do
    data
    |> Excrc32c.crc32c()
    |> mask_checksum()
  end

  defp mask_checksum(x) do
    (x >>> 15 ||| (x <<< 17 &&& 0xFFFFFFFF)) + 0xA282EAD8 &&& 0xFFFFFFFF
  end

  @doc """
  Creates chunks of specified size from a binary
  """
  def chunk_binary(binary, chunk_size), do: do_chunk_binary(binary, chunk_size, [])
  defp do_chunk_binary(<<>>, _chunk_size, acc), do: Enum.reverse(acc)

  defp do_chunk_binary(binary, chunk_size, acc) do
    {chunk, rest} = :erlang.split_binary(binary, min(byte_size(binary), chunk_size))
    do_chunk_binary(rest, chunk_size, [chunk | acc])
  end
end
