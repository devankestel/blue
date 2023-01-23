defmodule Blue.State do
  alias Blue.Canvas

  defstruct [
      canvas: Canvas.new()
  ]

  def new(), do: __struct__()
end
