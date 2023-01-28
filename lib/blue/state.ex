defmodule Blue.State do
  alias Blue.Canvas

  defstruct [
      canvas: Canvas.new(),
      filename: "state.json",
      designer_mode: false,
      add_protagonist_sprite: false,
      add_red_item_sprite: false,
      add_blue_item_sprite: false,
      add_wall_sprite: false,
      delete_sprite: false,
  ]

  def new(), do: __struct__()
end
