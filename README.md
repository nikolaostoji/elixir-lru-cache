# LruCache

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `lru_cache` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:lru_cache, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/lru_cache](https://hexdocs.pm/lru_cache).

## How to run

Go to lib directory and run "iex lru_cache.ex":
  * LruCache.create()/LruCache.create(10) - default value is 5
  * LruCache.put("test-key", 123) - to add to cache
  * LruCache.get("test-key") - to get value from cache
  * LruCache.delete("test-key) - to delete item from cache