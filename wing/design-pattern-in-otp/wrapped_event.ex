#coding:utf-8

# 封装状态/事件处理，和GenServer的差别是：GenEvent用于为现有服务添加处理方法，GenServer用于为服务提供框架
defmodule WrappedEvent do
  use GenEvent

  def handle_event(event, parent) do
    case event do
      :event ->
        send parent, :event
      :accident ->
        send parent, :accident
      _ ->
        send parent, :error
    end
    {:ok, parent}
  end
end

#====================================================
# usecase
#====================================================
# 
# c("wrapped_event.ex")
# {:ok, manager} = GenEvent.start_link
# 
# GenEvent.add_handler(manager, WrappedEvent, self())
# 
# GenEvent.sync_notify(manager, :event)
# flush
# 
# GenEvent.sync_notify(manager, :accident)
# flush
# 
# GenEvent.sync_notify(manager, :zero)
# flush
# 