#coding:utf-8

# 通用服务器架构，通过消息交互
defmodule WrappedServer do
  use GenServer

  def start(data, opt \\ []) do
    GenServer.start_link(__MODULE__, data, opt)
  end

  #====================================================
  # api for clients
  #====================================================
  def operate_call(server, name) do
    GenServer.call(server, {:operate_call, name})
  end

  # add more <operate>_call functions ...

  def operate_cast(server, name) do
    GenServer.cast(server, {:operate_cast, name})
  end

  # add more <operate>_cast functions ...

  #====================================================
  # callbacks for server
  #====================================================
  def init(data) do
    {:ok, data}
  end

  def handle_call({:operate_call, name}, _from, data) do
    return = Map.get(data, name, "none") # pending to reconstruct
    {:reply, return, data}
  end

  # ... pattern matching

  def handle_cast({:operate_cast, name}, data) do
    data = Map.put(data, name, String.length(to_string(name))) # pending to reconstruct
    {:noreply, data}
  end

  # ... pattern matching
end

#====================================================
# usecase
#====================================================
# 
# c("wrapped_server.ex")
# {:ok, server} = WrappedServer.start(Map.new)
# 
# WrappedServer.operate_cast(server, "name")
# WrappedServer.operate_call(server, "name")
# 