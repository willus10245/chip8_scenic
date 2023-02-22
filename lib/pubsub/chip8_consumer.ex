defmodule Chip8Scenic.PubSub.Chip8Consumer do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def render(display) do
    GenServer.cast(__MODULE__, {:emulator, display})
  end

  @impl GenServer
  def init(_) do
    Scenic.PubSub.register(:emulator)
    Scenic.PubSub.publish(:emulator, Chip8.Display.new())

    {:ok, %{}}
  end

  @impl GenServer
  def handle_cast({:emulator, display}, _) do
    Scenic.PubSub.publish(:emulator, display)
    Logger.debug("PUBLISHED DISPLAY DATA")

    {:noreply, %{}}
  end
end
