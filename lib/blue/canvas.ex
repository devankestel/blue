defmodule Blue.Canvas do
  alias Blue.{Sprite, Svg}

  @type grid_size :: integer
  @type width :: integer
  @type height :: integer

  defstruct [
    grid_size: 20,
    width: 200,
    height: 400,
    sprites: []
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

def can_collect_item?(
  direction,
  protagonist_grid_coordinate,
  item_grid_coordinate
  ) do

  {protagonist_col, protagonist_row} = protagonist_grid_coordinate
  {item_col, item_row} = item_grid_coordinate

  case direction do
    :left -> (protagonist_col - 1 == item_col) and (protagonist_row == item_row)
    :right -> (protagonist_col + 1 == item_col) and (protagonist_row == item_row)
    :up -> (protagonist_col == item_col) and (protagonist_row - 1 == item_row)
    :down -> (protagonist_col == item_col) and (protagonist_row + 1 == item_row)
    _ -> false
  end
end

def render(canvas) do
  header = Svg.header(canvas)
  footer = Svg.footer()

  sprite_svgs = canvas.sprites |>
    Enum.map(
      fn sprite ->
        Svg.square(canvas, sprite)
      end
    )

  middle = Enum.join(sprite_svgs)

  Enum.join([header, middle, footer])
end
end
