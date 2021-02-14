defmodule LruCache do
  @moduledoc """
  Documentation for `LruCache`.

  ## How to run
  LruCache.create()


  """

  use GenServer

  ### Client API
 
  @doc """
  Creates a LRU cache

  ## Examples

      iex> LruCache.create()

  """
  def create() do
    GenServer.start_link(__MODULE__, [], name: :lru_cache_genserver)
  end 

  @doc """
  Adds a kvp to the cache. If the cache capacity exceeds, removes 
  the least recently used key. If the key does not existIf key 
  already exists, updates the value and returns false.  

  ## Parameters

    - key: key
    - value: value

  ## Examples

      iex> LruCache.put("test-key", 123)
      true

  """
  def put(key, value) do 
    GenServer.call(:lru_cache_genserver, {:put, key, value})
  end

  @doc """
  Gets value if key is present, returns nil otherwise.

  ## Parameters

    - key: key

  ## Examples

      iex> LruCache.get("key-exists")

  """
  def get(key) do
    GenServer.call(:lru_cache_genserver, {:get, key})
  end

  @doc """
  Removes a kvp from the cache.

  ## Parameters

    - key: key

  ## Examples

      iex> LruCache.delete("key")
      true

  """
  def delete(key) do
    GenServer.call(:lru_cache_genserver, {:delete, key})
  end 

  ### Server Callbacks
  
  def init(init_arg) do
    :ets.new(:foo, [:set, :named_table, :public])
    {:ok, init_arg}
  end

  def handle_call({:put, key, value}, _from, items) do
    result = :ets.insert_new(:foo, {key, value})
    {:reply, result, items}
  end

  def handle_call({:get, key}, _from, items) do
      result = :ets.lookup(:foo, key)
      case result do
        [{_, val}] -> # key in cache
          {:reply, val, items}
        [] -> # key not found in cache
          {:reply, nil, items}
      end
  end

  def handle_call({:delete, key}, _from, items) do
    result = :ets.delete(:foo, key)
    {:reply, result, items}
  end
end
