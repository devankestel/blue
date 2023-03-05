defmodule Blue.Svg do
  alias Blue.Sprite

  def header(canvas, designer_mode) do
    # we need to conditionally render the click event
    # or the keypress event based on which mode
    # we are in
    IO.inspect("render designer mode #{designer_mode}")
    event = case designer_mode do
      true -> 'phx-click="svg_click"'
      false -> 'phx-window-keydown="keypress"'
    end
    """
    <svg #{event}
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
    style="fill:rgba(#{color_vector});"
    width="#{canvas.grid_size}" height="#{canvas.grid_size}"/>
    """
  end

  def get_coordinate(canvas, sprite) do
    {col, row} = sprite.grid_coordinate
    {(col-1)*canvas.grid_size, (row-1)*canvas.grid_size}
  end

  def get_grid_coordinate(coordinate, canvas) do
    {x, y} = coordinate
    col = (x/canvas.grid_size)
    |> ceil()

    row = (y/canvas.grid_size)
    |> ceil()

    {col, row}
  end

end
