defmodule Blue.Concept do
    defstruct [
        position: {0, 0}
    ]
    
    def new(), do: __struct__

    def move_avatar(avatar, direction) do
        %{avatar | position: move(avatar.position, direction)}
    end

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