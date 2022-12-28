defmodule Blue.Concept do
    defstruct [
        position: {0, 0}
    ]
    
    def new(), do: __struct__
end