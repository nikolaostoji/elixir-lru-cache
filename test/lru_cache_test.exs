defmodule LruCacheTest do
  use ExUnit.Case
  doctest LruCache

  setup do
    {:ok,server_pid} = LruCache.create(3)
    {:ok,server: server_pid}
  end

  test "tests put() returns true when adding element" do
    assert LruCache.put("abc", "123") == true
  end

  test "tests get() returns ok if key is in cache" do
    LruCache.put("abc", "123")
    assert LruCache.get("abc") == "123"
  end

  test "tests get() returns nil if key DNE in cache" do
    assert LruCache.get("abc") == nil
  end

  test "tests delete() removes element" do
    LruCache.put("abc", "123")
    assert LruCache.get("abc") == "123"

    LruCache.delete("abc")
    assert LruCache.get("abc") == nil
  end
end

