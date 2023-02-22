defmodule Chip8Scenic do
  @moduledoc """
  Starter application using the Scenic framework.
  """

  def start(_type, _args) do
    # load the viewport configuration from config
    main_viewport_config = Application.get_env(:chip8_scenic, :viewport)

    # start the application with the viewport
    children = [
      {Chip8, ["../chip8/roms/ibm.ch8"]},
      {Registry, [keys: :unique, name: SceneRegistry]},
      {Scenic, [main_viewport_config]},
      Chip8Scenic.PubSub.Supervisor
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
