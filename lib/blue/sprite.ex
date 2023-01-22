defmodule Blue.Color do
    alias Blue.Color

    defstruct [
        black: {0, 0, 0, 1},
        red: {255, 0, 0, 1},
        green: {0, 255, 0, 1},
        blue: {0, 0, 255, 1},
        white: {255, 255, 255, 1},
        gray: {100, 100, 100, 1}
    ]

    def new(), do: __struct__()
end

defmodule Blue.Sprite do

    alias Blue.Sprite
    alias Blue.Color

    @colors Color.new()

    @type grid_coordinate :: {integer, integer}
    @type direction :: :up | :down | :left | :right
    @type color :: :black | :red
    @type type :: :none | :item | :protagonist
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

    @spec get_color_vector(Sprite.t()) :: {integer, integer, integer, integer}
    def get_color_vector(sprite) do
        @colors
        |> Map.get(sprite.color)
    end

end
