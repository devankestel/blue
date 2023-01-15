defmodule Blue.Svg do
  alias Blue.Sprite

  def square(canvas, sprite) do
    color_vector = Sprite.get_color_vector(sprite) |> Tuple.to_list() |> Enum.join(",")
    {x, y} = get_coordinate(canvas, sprite)
    """
    <rect
      x="#{x}" y="#{y}"
      style="fill:#rgba(#{color_vector});"
      width="#{canvas.grid_size}" height="#{canvas.grid_size}"/>
    """
  end

  def get_coordinate(canvas, sprite) do
    {col, row} = sprite.grid_coordinate
    {(col-1)*canvas.grid_size, (row-1)*canvas.grid_size}
  end

end
