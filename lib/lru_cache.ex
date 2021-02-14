defmodule LruCache do
  @moduledoc """
  Documentation for `LruCache`.

  ## How to run
  LruCache.create()


  """

  use GenServer
  defstruct capacity: 0

  ### Client API
 
  @doc """
  Creates a LRU cache

  ## Examples

      iex> LruCache.create()

  """
  def create(capacity \\ 3) do
    GenServer.start_link(__MODULE__, capacity, name: :lru_cache_genserver)
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

  #TODO: remove, just for testing
  def display_entire_cache() do
    :ets.tab2list(:cache_table)
    :ets.tab2list(:position_table)
  end
  
  def init(capacity) do
    :ets.new(:cache_table, [:named_table, :public]) 
    :ets.new(:position_table, [:named_table, :ordered_set])
    lru_state = %LruCache{capacity: capacity} 
    {:ok, lru_state}
  end

  def handle_call({:put, key, value}, _from, lru_state) do
    result = :ets.insert_new(:cache_table, {key, value})
    update_item_position(key)
    remove_least_recently_used(lru_state)
    {:reply, result, lru_state}
  end

  def handle_call({:get, key}, _from, lru_state) do
      result = :ets.lookup(:cache_table, key)
      case result do
        [{_, val}] -> 
          update_item_position(key)
          {:reply, val, lru_state}
        [] -> # key not found in cache
          {:reply, nil, lru_state}
      end
  end

  def handle_call({:delete, key}, _from, lru_state) do
    result = :ets.delete(:cache_table, key)
    :ets.delete(:position_table, key)
    {:reply, result, lru_state}
  end

  defp remove_least_recently_used(lru_state) do
    # if we exceed capacity remove least recently used item
    num_items = :ets.info(:cache_table, :size)
    if num_items > lru_state.capacity do 
      lru_key = :ets.first(:position_table)
      :ets.delete(:position_table, lru_key)
      :ets.delete(:cache_table, lru_key)
    end
  end

  defp update_item_position(key) do
    # Puts item in back of table
    counter = :erlang.unique_integer([:monotonic])
    :ets.delete(:position_table, key)
    :ets.insert(:position_table, {key, counter})
  end
end
