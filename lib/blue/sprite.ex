defmodule Blue.Color do
    alias Blue.Color

    @type color :: :black | :red | :gray | :blue | :white | :neon_yellow | :green
    @type rgba_vector :: {integer(), integer(), integer(), integer()}
    @type t :: %Color{
      black: rgba_vector(),
      red: rgba_vector(),
      green: rgba_vector(),
      blue: rgba_vector(),
      white: rgba_vector(),
      gray: rgba_vector(),
      neon_yellow: rgba_vector()
    }

    defstruct [
        black: {0, 0, 0, 1},
        red: {255, 0, 0, 1},
        green: {0, 255, 0, 1},
        blue: {0, 0, 255, 1},
        white: {255, 255, 255, 1},
        gray: {100, 100, 100, 1},
        neon_yellow: {224,231,34, 1}
    ]

    def new(), do: __struct__()

    @spec to_atom(String.t()) :: color()
    def to_atom(color_string) do
      case color_string do
        "black" -> :black
        "red" -> :red
        "green" -> :green
        "blue" -> :blue
        "white" -> :white
        "gray" -> :gray
        _ -> :neon_yellow
      end
    end
end

defmodule Blue.Direction do
  @type direction :: :left | :right | :up | :down

  @spec from_key_to_atom(String.t()) :: direction
  def from_key_to_atom(key_pressed) do
    case key_pressed do
      "ArrowLeft" -> :left
      "ArrowRight" -> :right
      "ArrowUp" -> :up
      "ArrowDown" -> :down
      _ -> :nomatch
    end
  end
end

defmodule Blue.Sprite do

    alias Blue.Sprite
    alias Blue.Color

    @colors Color.new()

    @type grid_coordinate :: {integer, integer}
    @type direction :: :up | :down | :left | :right
    @type color :: :black | :red | :gray | :blue | :white | :neon_yellow | :green
    @type rgba_vector :: {integer(), integer(), integer(), integer()}
    @type type :: :none | :item | :protagonist | :wall
    @type t :: %Sprite{grid_coordinate: grid_coordinate(), color: color, type: type}

    defstruct [
        grid_coordinate: {1, 1},
        color: :black,
        type: :none
    ]

    @spec new() :: Sprite.t()
    def new(), do: __struct__()

    @spec move(Sprite.t(), direction) :: Sprite.t()
    def move(sprite, direction) do
        %{sprite | grid_coordinate: update_grid_coordinate(sprite.grid_coordinate, direction)}
    end

    @spec update_grid_coordinate(grid_coordinate(), grid_coordinate()) :: grid_coordinate()
    def update_grid_coordinate(grid_coordinate, direction) do
        {col, row} = grid_coordinate
        case direction do
            :up ->
                {col, row-1}
            :down ->
                {col, row+1}
            :left ->
                {col-1, row}
            :right ->
                {col+1, row}
            _ ->
                {col, row}
        end
    end

    @spec from_json(String.t()) :: Sprite.t()
    def from_json(sprite_json_string) do
      %Sprite{
        grid_coordinate: {
          sprite_json_string["grid_coordinate"]["col"],
          sprite_json_string["grid_coordinate"]["row"]
        },
        color: Color.to_atom(sprite_json_string["color"]),
        type: Sprite.type_to_atom(sprite_json_string["type"])
      }
    end

    @spec mapify(Sprite.t()) :: String.t()
    def mapify(sprite) do
      {col, row} = sprite.grid_coordinate
        %{
          grid_coordinate: %{col: col, row: row},
          type: Atom.to_string(sprite.type),
          color: Atom.to_string(sprite.color),
        }
    end

    @spec type_to_atom(String.t()) :: type()
    def type_to_atom(type_string) do
      case type_string do
        "protagonist" -> :protagonist
        "item" -> :item
        "wall" -> :wall
        _ -> :none
      end
    end

    @spec get_color_vector(Sprite.t()) :: rgba_vector()
    def get_color_vector(sprite) do
        @colors
        |> Map.get(sprite.color)
    end

end
