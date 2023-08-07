#coding:utf-8

# 监督进程用于管理其他进程的运行状态，发现异常进程立刻重启（监督者功能越单一越好）
# 监督重启策略:
# :one_for_one 一个进程出错，它的监督进程就重启该进程
# :one_for_all 一个进程出错，它的监督进程重启所有关联进程
# :rest_for_one 一个进程出错，它的监督进程重启该进程和所有依赖该进程的进程
# :simple_one_for_one 一个进程出错，它的监督进程就重启该进程，且一个监督进程只能关联一个进程
defmodule WrappedSupervisor do
  import Supervisor.Spec

  def init() do
    children = [
      worker(PseudoServerA, [[], [name: :server_a]]),
      worker(PseudoServerB, [[], [name: :server_b]]),
      worker(PseudoServerC, [[], [name: :server_c]])
    ]

    # Start the supervisor with children
    Supervisor.start_link(children, strategy: :rest_for_one)
  end
end

# 监督进程也可以监督监督进程
defmodule SupervisorBranch do
  import Supervisor.Spec

  def start_link(state) do
    children = [
      worker(PseudoServerA, [[], [name: :server_a]]),
      worker(PseudoServerB, [[], [name: :server_b]]),
    ]

    # Start the supervisor with children
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end

defmodule SupervisorRoot do
  import Supervisor.Spec

  def init() do
    children = [
      supervisor(SupervisorBranch, [[name: :supervisor_branch]]),
      worker(PseudoServerC, [[], [name: :server_c]])
    ]

    # Start the supervisor with children
    Supervisor.start_link(children, strategy: :one_for_all)
  end
end


defmodule PseudoServerA do
  use GenServer

  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def handle_call(:display, _from, []) do
    {:reply, 'ServerA PID: ' ++ :erlang.pid_to_list(self()), []}
  end

  def handle_cast(:err, []) do
    {:stop, "stop ServerA", []}
  end
end

defmodule PseudoServerB do
  use GenServer

  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def handle_call(:display, _from, []) do
    {:reply, 'ServerB PID: ' ++ :erlang.pid_to_list(self()), []}
  end

  def handle_cast(:err, []) do
    {:stop, "stop ServerB", []}
  end
end

defmodule PseudoServerC do
  use GenServer

  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def handle_call(:display, _from, []) do
    {:reply, 'ServerC PID: ' ++ :erlang.pid_to_list(self()), []}
  end

  def handle_cast(:err, []) do
    {:stop, "stop ServerC", []}
  end
end

#====================================================
# usecase
#====================================================
# 
# c("wrapped_supervisor.ex")
# 
# 1. 监督者-->工作者
# WrappedSupervisor.init
# 
# GenServer.call(:server_a, :display)
# GenServer.call(:server_b, :display)
# GenServer.call(:server_c, :display)
# 
# GenServer.cast(:server_a, :err)
# 
# GenServer.call(:server_a, :display)
# GenServer.call(:server_b, :display)
# GenServer.call(:server_c, :display)
# 
# 更换重启策略后再试试
# ...
#
# 2.监督者-->监督者-->工作者
# SupervisorRoot.init
#
# GenServer.call(:server_a, :display)
# GenServer.call(:server_b, :display)
# GenServer.call(:server_c, :display)
#
# GenServer.cast(:server_a, :err)
# GenServer.cast(:server_c, :err)
#
# GenServer.call(:server_a, :display)
# GenServer.call(:server_b, :display)
# GenServer.call(:server_c, :display)
#