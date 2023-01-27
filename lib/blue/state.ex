defmodule Blue.State do
  alias Blue.Canvas

  defstruct [
      canvas: Canvas.new(),
      filename: "state.json"
  ]

  def new(), do: __struct__()
end
