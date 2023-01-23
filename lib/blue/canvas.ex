defmodule Blue.Canvas do
  alias __MODULE__
  alias Blue.{Sprite, Color, Svg}

  @type grid_size :: integer
  @type width :: integer
  @type height :: integer

  defstruct [
    grid_size: 20,
    width: 200,
    height: 400,
    sprites: []
]


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

def get_sprites_by_type(canvas, type) do
  canvas.sprites |>
  Enum.filter(
    fn s ->
      s.type == type
    end
    )
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

def has_adjacent_sprite?(
  canvas,
  direction,
  grid_coordinate
  ) do

  {col, row} = grid_coordinate

  canvas.sprites
    |> Enum.any?(
      fn s ->
        case direction do
          :left -> s.grid_coordinate == {col - 1, row}
          :right -> s.grid_coordinate == {col + 1, row}
          :up -> s.grid_coordinate == {col, row - 1}
          :down -> s.grid_coordinate == {col, row + 1}
          _ -> false
        end
      end
    )
end

def get_adjacent_sprite(
  canvas,
  direction,
  grid_coordinate
) do
  {col, row} = grid_coordinate

  canvas.sprites
    |> Enum.filter(
      fn s ->
        case direction do
          :left -> s.grid_coordinate == {col - 1, row}
          :right -> s.grid_coordinate == {col + 1, row}
          :up -> s.grid_coordinate == {col, row - 1}
          :down -> s.grid_coordinate == {col, row + 1}
          _ -> false
        end
      end
    )
  |> Enum.at(0)
end

def has_item?(canvas) do
  canvas.sprites |> Enum.count >= 2
end

def remove_sprite(canvas, sprite) do
  filtered_sprites =
    canvas.sprites |>
    Enum.filter(
      fn s ->
        s.grid_coordinate != sprite.grid_coordinate
      end
    )
  %{canvas | sprites: filtered_sprites}
end

def move_sprite(canvas, sprite, direction) do
  grid_coordinate = sprite.grid_coordinate
  updated_sprites =
    canvas.sprites
    |> Enum.map(
      fn s ->
        case s.grid_coordinate do
          ^grid_coordinate -> Sprite.move(sprite, direction)
          _ -> s
        end
      end
    )
  %{canvas | sprites: updated_sprites}
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

def from_json(path) do
  {:ok, contents} = File.read(path)
  raw_canvas_map = Jason.decode!(contents)
  sprites = raw_canvas_map["sprites"]
    |> Enum.map(
      fn s ->
        Sprite.from_json(s)
      end
    )
  %Canvas{
    grid_size: raw_canvas_map["grid_size"],
    width: raw_canvas_map["width"],
    height: raw_canvas_map["height"],
    sprites: sprites
  }
end

def to_json(canvas, path) do
  canvas_map = Canvas.mapify(canvas)
  canvas_json_string = Jason.encode!(canvas_map)
  {:ok, file} = File.open(path, [:write])
  IO.binwrite(file, canvas_json_string)
  File.close(file)
end

def mapify(canvas) do
  %{
    width: canvas.width,
    height: canvas.height,
    grid_size: canvas.grid_size,
    sprites: canvas.sprites
                |> Enum.map(fn s -> Sprite.mapify(s) end)
  }
end

end
