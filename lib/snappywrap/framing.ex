defmodule Snappywrap.Framing do
  @moduledoc """
  The Snappy framing format is an optional Snappy format.

  It consists of a stream identifier header `0xff 0x06 0x00 0x00 0x73 0x4e 0x61 0x50 0x70 0x59`, followed by a series of chunks.
  In this wrapper implementation, each chunk can only be an uncompressed data chunk (identifier: `0x01`).

  Snappy chunks have the following format:
  - `1 byte`: chunk `type` (0x01 for uncompressed data)
  - `3 bytes`: chunk `length` (little-endian)
  - `4 bytes`: masked CRC-32C `checksum` of the chunk data
  - `N bytes`: chunk `data`
  """

  # Constants for Snappy framing format
  @snappy_stream_identifier <<0xFF, 0x06, 0x00, 0x00, 0x73, 0x4E, 0x61, 0x50, 0x70, 0x59>>
  @uncompressed_chunk_identifier 0x01
  @crc_length 4
  # An uncompressed data chunk, like compressed data chunks, should contain
  # no more than 65536 data bytes, so the maximum legal chunk length with the checksum is 65540.
  @uncompressed_chunk_max_size 65536

  @doc """
    Encodes as _uncompressed_ data in Snappy `framing` format.

    Input data size is assumed to be valid.
  """
  def encode(data) when is_binary(data), do: encode_data(data)

  # Private functions

  defp encode_data(data) when is_binary(data) do
    # Snappy identifier
    snappy_identifier = @snappy_stream_identifier
    chunks = split_and_encode_chunks(data)
    <<snappy_identifier::binary, chunks::binary>>
  end

  # Splits data into chunks (max size: 65536 bytes) and encodes each as a uncompressed chunk
  defp split_and_encode_chunks(data) do
    data
    |> Snappywrap.Helper.chunk_binary(@uncompressed_chunk_max_size)
    |> Enum.map(fn chunk -> build_chunk(@uncompressed_chunk_identifier, chunk) end)
    |> Enum.join()
  end

  # Builds a Snappy chunk with the given type and data
  defp build_chunk(chunk_type, chunk_data) do
    chunk_size = byte_size(chunk_data) + @crc_length
    crc = Snappywrap.Helper.crc(chunk_data)
    # Chunk format: 1 byte type + 3 bytes length + 4 bytes CRC + data
    <<chunk_type::8, chunk_size::little-size(24), crc::little-size(32), chunk_data::binary>>
  end
end
