defmodule Chip8Scenic.Scene.Chip8 do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph

  import Scenic.Primitives
  # import Scenic.Components

  @cell_size 15
  @max_x 63
  @max_y 31

  # @pubsub_data {Scenic.PubSub, :data}
  # @pubsub_registered {Scenic.PubSub, :registered}

  def render(display) do
    [{_, pid}] = Registry.lookup(SceneRegistry, __MODULE__)
    GenServer.cast(pid, {:render, display})
  end

  # ============================================================================
  # setup

  # --------------------------------------------------------
  @impl Scenic.Scene
  def init(scene, _param, _opts) do
    Registry.register(SceneRegistry, __MODULE__, scene.pid)
    Scenic.PubSub.subscribe(:emulator)
    rects = build_rects()

    graph =
      Graph.build()
      |> add_specs_to_graph(rects)
    
    scene = push_graph(scene, graph)

    {:ok, scene}
  end

  @impl GenServer
  def handle_cast({:render, display}, scene) do
    rects = build_rects(display)

    graph =
      Graph.build()
      |> add_specs_to_graph(rects)
    
    scene = push_graph(scene, graph)

    {:noreply, scene}
  end

  # @impl GenServer
  # def handle_info({@pubsub_registered, _}, scene) do
  #   {:ok, scene}
  # end
  #
  # def handle_info({@pubsub_data, {:emulator, display, _}}, scene) do
  #   IO.puts "GOT DATA"
  #   rects = build_rects(display)
  #
  #   graph =
  #     Graph.build()
  #     |> add_specs_to_graph(rects)
  #   
  #   scene = push_graph(scene, graph)
  #
  #   {:noreply, scene}
  # end

  @impl Scenic.Scene
  def handle_input(event, _context, scene) do
    Logger.info("Received event: #{inspect(event)}")
    {:noreply, scene}
  end

  defp build_rects() do
    0..@max_y
    |> Enum.flat_map(fn y -> 
      0..@max_x
      |> Enum.map(fn x -> rect_spec({@cell_size, @cell_size}, fill: :black, t: {x * @cell_size, y * @cell_size}) end)
    end)
  end

  defp build_rects(display) do
    0..@max_y
    |> Enum.flat_map(fn y -> 
      0..@max_x
      |> Enum.map(fn x -> rect_spec({@cell_size, @cell_size}, fill: fill(display[{x, y}]), t: {x * @cell_size, y * @cell_size}, id: {x, y}) end)
    end)
  end

  defp fill(1), do: :green
  defp fill(0), do: :black
end
