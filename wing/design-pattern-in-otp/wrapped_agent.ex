#coding:utf-8

# 使用Agent封装状态，用于在进程间共享数据
defmodule WrappedAgent do
  def start do
    Agent.start_link(fn -> Map.new end, name: __MODULE__)
  end

  def get(key) do
    Agent.get(__MODULE__, fn map ->
      if Map.has_key?(map, key) do
        Map.get(map, key)
      else
        nil
      end
    end)
  end

  def put(key, val) do
    Agent.update(__MODULE__, &Map.put(&1, key, val))
  end

  def delete(key) do
    Agent.get_and_update(__MODULE__, fn map ->
      if Map.has_key?(map, key) do
        Map.pop(map, key)
      else
        nil
      end
    end)
  end

  def keys do
    Map.new
  end
end

#====================================================
# usecase
#====================================================
# c("wrapped_agent.ex")
# WrappedAgent.start
# 
# WrappedAgent.get("key")
# 
# WrappedAgent.put("key", "val")
# WrappedAgent.get("key")
# 
# WrappedAgent.delete("key")
# WrappedAgent.get("key")
# 