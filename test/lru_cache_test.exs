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

  test "tests adding when at capacity will remove item that was lru" do
    LruCache.put("a", "1")
    LruCache.put("b", "2")
    LruCache.put("c", "3")
    LruCache.put("d", "4")

    assert LruCache.get("a") == nil
    assert LruCache.get("b") == "2"
    assert LruCache.get("c") == "3"
    assert LruCache.get("d") == "4"
  end

  test "tests fetching an item will reset its position" do
    LruCache.put("a", "1")
    LruCache.put("b", "2")
    LruCache.put("c", "3")
    LruCache.get("a")
    LruCache.put("d", "4")

    assert LruCache.get("a") == "1"
    assert LruCache.get("b") == nil
    assert LruCache.get("c") == "3"
    assert LruCache.get("d") == "4"
  end

  test "tests deleting an item frees up room" do
    LruCache.put("a", "1")
    LruCache.put("b", "2")
    LruCache.put("c", "3")
    LruCache.delete("c")
    LruCache.put("d", "4")

    assert LruCache.get("a") == "1"
    assert LruCache.get("b") == "2"
    assert LruCache.get("c") == nil
    assert LruCache.get("d") == "4"
  end
end

