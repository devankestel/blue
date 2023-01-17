defmodule Blue.Svg do
  alias Blue.Sprite

  def header(canvas) do
    """
    <svg
    version="1.0"
    style="background-color: #F8F8F8"
    id="Layer_1"
    xmlns="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    width="200" height="400"
    viewBox="0 0 #{canvas.width} #{canvas.height}"
    xml:space="preserve">
    """
  end

  def footer(), do: "</svg>"

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
