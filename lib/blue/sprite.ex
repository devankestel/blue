defmodule Blue.Color do
    alias Blue.Color

    defstruct [
        black: {0, 0, 0, 1},
        red: {255, 0, 0, 1},
        green: {0, 255, 0, 1},
        blue: {0, 0, 255, 1},
        white: {255, 255, 255, 1}
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
    @type t :: %Sprite{grid_coordinate: grid_coordinate(), color: color}

    defstruct [
        grid_coordinate: {1, 1},
        color: :black
    ]

    @spec new() :: Sprite.t()
    def new(), do: __struct__()

    @spec move(Sprite.t(), direction) :: Sprite.t()
    def move(sprite, direction) do
        %{sprite | grid_coordinate: update_grid_coordinate(sprite.grid_coordinate, direction)}
    end

    @spec update_grid_coordinate(grid_coordinate(), grid_coordinate()) :: grid_coordinate()
    def update_grid_coordinate(grid_coordinate, direction) do
        {x, y} = grid_coordinate
        case direction do
            :up ->
                {x, y-1}
            :down ->
                {x, y+1}
            :left ->
                {x-1, y}
            :right ->
                {x+1, y}
            _ ->
                {x, y}
        end
    end

    @spec get_color_vector(Sprite.t()) :: {integer, integer, integer, integer}
    def get_color_vector(sprite) do
        @colors
        |> Map.get(sprite.color)
    end

end
