defmodule Mvp.Counter do
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def increment() do
    GenServer.call(__MODULE__, :increment)
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  @impl true
  def init(_) do
    {:ok, %{count: 0}}
  end

  @impl true
  def handle_call(:increment, _from, %{count: count}) do
    count = count + 1
    {:reply, count, %{count: count}}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end
end
