#coding:utf-8

# 执行某些单一、独立、数据和交互都互不关联的操作过程的模块
defmodule WrappedTask do
  def do_sync(set) do
    for elem <- set do
      IO.puts "sync running" # ...
    end
  end

  def do_async(set) do
    for elem <- set do
      Task.start_link( fn ->
        IO.puts "async running" # ...
      end)
    end
  end

  def run(set) do
    prod = Task.async(fn ->
      IO.puts "async running" # ...
    end)
    prod
  end
end

#====================================================
# usecase
#====================================================
#
# c("wrapped_task.ex") # r(WrappedTask)
# 
# a = WrappedTask.run([1,2,3,4])
# b = WrappedTask.do_sync([1,2,3,4])
#
#
