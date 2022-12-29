defmodule Blue.Protagonist do
    alias Blue.Sprite
    alias Blue.Protagonist

    @type t :: %Protagonist{step_count: integer, sprite: Sprite.t()}

    defstruct [
        step_count: 0,
        sprite: Sprite.new()
    ]
    
    @spec new() :: Protagonist.t()
    def new(), do: __struct__()
end