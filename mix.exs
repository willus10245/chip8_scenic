defmodule Chip8Scenic.MixProject do
  use Mix.Project

  def project do
    [
      app: :chip8_scenic,
      version: "0.1.0",
      elixir: "~> 1.9",
      build_embedded: true,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Chip8Scenic, []},
      extra_applications: [:crypto]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:chip8, path: "../chip8"},
      {:scenic, "~> 0.11.0"},
      {:scenic_driver_local, "~> 0.11.0"},
    ]
  end
end
