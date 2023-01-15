defmodule Blue.Canvas do
  alias Blue.Sprite

  @type grid_size :: integer
  @type width :: integer
  @type height :: integer

  defstruct [
    grid_size: 20,
    width: 200,
    height: 400,
    sprites: [Sprite.new(), Sprite.new()]
]

@spec new() :: Canvas.t()
def new(), do: __struct__()

def get_num_cols(canvas) do
  canvas.width/canvas.grid_size
end

def get_num_rows(canvas) do
  canvas.height/canvas.grid_size
end

def is_at_grid_edge?(canvas, direction, grid_coordinate) do
  {col, row} = grid_coordinate

    case direction do
      :left -> col <= 1
      :right -> col >= get_num_cols(canvas)
      :up -> row <= 1
      :down -> row >= get_num_rows(canvas)
      _ -> false
    end
end
end
