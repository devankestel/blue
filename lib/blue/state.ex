defmodule Blue.State do
  alias Blue.{Canvas, DesignerMode}

  defstruct [
      canvas: Canvas.new(),
      filename: "live.json",
      designer_mode: DesignerMode.new()
  ]

  def new(), do: __struct__()
end
