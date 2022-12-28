defmodule Blue.Concept do
    alias Blue.Concept

    defstruct [
        position: {0, 0}
    ]
    
    @spec new() :: %Concept{}
    def new(), do: __struct__()

    @spec move_avatar(%Concept{}, atom) :: %Concept{} 
    def move_avatar(avatar, direction) do
        %{avatar | position: move(avatar.position, direction)}
    end

    @spec move({integer, integer}, atom) :: {integer, integer}
    def move(position, direction) do
        {x, y} = position
        case direction do
            :up ->
                {x, y+1}
            :down -> 
                {x, y-1}
            :left -> 
                {x-1, y}
            :right -> 
                {x+1, y}
            _ -> 
                {x, y} 
        end
    end
end