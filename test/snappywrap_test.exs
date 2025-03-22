defmodule SnappywrapTest do
  use ExUnit.Case

  test "wrap handles binary data within size limit" do
    data = "hello world"
    assert {:ok, _wrapped} = Snappywrap.wrap(data)
    assert {:ok, _wrapped} = Snappywrap.wrap_framed(data)
  end

  @tag :skip
  test "wrap returns error when data exceeds max size" do
    # Create data larger than input_max_bytes
    large_data = String.duplicate("a", Snappywrap.Helper.input_max_bytes() + 1)
    assert {:error, message} = Snappywrap.wrap(large_data)
    assert message =~ "Input exceeds the maximum allowed size"
    assert {:error, message} = Snappywrap.wrap_framed(large_data)
    assert message =~ "Input exceeds the maximum allowed size"
  end

  test "wrap only accepts binary input" do
    assert_raise FunctionClauseError, fn -> Snappywrap.wrap(123) end
    assert_raise FunctionClauseError, fn -> Snappywrap.wrap_framed(123) end
  end
end
