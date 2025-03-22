defmodule Snappywrap.BlockTest do
  use ExUnit.Case

  test "encode outputs expected binary" do
    expected_output = <<11, 40, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100>>

    data = "hello world"
    wrapped = Snappywrap.Block.encode(data)
    assert wrapped == expected_output
  end

  test "encode data over of over 60 length" do
    expected_output =
      <<72, 240, 71, 97, 32, 108, 111, 110, 103, 101, 114, 32, 115, 116, 114, 105, 110, 103, 32, 119, 105, 116, 104, 32, 111, 118,
        101, 114, 32, 116, 104, 101, 32, 55, 98, 105, 116, 32, 108, 105, 109, 105, 116, 32, 100, 97, 116, 97, 32, 43, 45, 42, 47,
        32, 49, 50, 51, 52, 53, 54, 55, 56, 57, 48, 32, 44, 46, 91, 93, 123, 125, 32, 39, 195, 172>>

    data = "a longer string with over the 7bit limit data +-*/ 1234567890 ,.[]{} 'ì"
    wrapped = Snappywrap.Block.encode(data)
    assert wrapped == expected_output
  end

  test "encode data over of over 60 length with multiple literal length bytes" do
    expected_output =
      <<212, 3, 244, 211, 1, 104, 101, 108, 108, 111, 49, 50, 51, 116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51,
        116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51, 116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51,
        116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51, 116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51,
        116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51, 116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51,
        116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51, 116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51,
        116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51, 116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51,
        116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51, 116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51,
        116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51, 116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51,
        116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51, 116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51,
        116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51, 116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51,
        116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51, 116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51,
        116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51, 116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51,
        116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51, 116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51,
        116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51, 116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51,
        116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51, 116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51,
        116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51, 116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51,
        116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51, 116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51,
        116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51, 116, 101, 115, 116, 50, 104, 101, 108, 108, 111, 49, 50, 51,
        116, 101, 115, 116, 50>>

    data =
      "hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2hello123test2"

    wrapped = Snappywrap.Block.encode(data)
    assert wrapped == expected_output
  end

  test "decompress wrapped" do
    data = "hello world"
    wrapped = Snappywrap.Block.encode(data)
    assert {:ok, ^data} = Snappyrex.decompress(wrapped, format: :raw)
    data = :crypto.strong_rand_bytes(10_000_000)
    wrapped = Snappywrap.Block.encode(data)
    assert {:ok, ^data} = Snappyrex.decompress(wrapped, format: :raw)
  end
end
