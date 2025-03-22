defmodule Snappywrap.FramingTest do
  use ExUnit.Case

  test "encode outputs expected binary" do
    expected_output =
      <<255, 6, 0, 0, 115, 78, 97, 80, 112, 89, 1, 15, 0, 0, 0, 126, 216, 109, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108,
        100>>

    data = "hello world"
    wrapped = Snappywrap.Framing.encode(data)
    assert wrapped == expected_output
  end

  test "decompress wrapped" do
    data = "hello world"
    wrapped = Snappywrap.Framing.encode(data)
    assert {:ok, ^data} = Snappyrex.decompress(wrapped, format: :frame)
    data = :crypto.strong_rand_bytes(10_000_000)
    wrapped = Snappywrap.Framing.encode(data)
    assert {:ok, ^data} = Snappyrex.decompress(wrapped, format: :frame)
  end
end
