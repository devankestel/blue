defmodule Blue.SvgTest do
  use ExUnit.Case
  alias Blue.Canvas
  alias Blue.Sprite
  alias Blue.Svg

  describe "square/2" do
    test "it creates a black square" do
      canvas = Canvas.new()
      sprite = Sprite.new()

      expected_square =
      """
      <rect
        x="0" y="0"
        style="fill:#rgba(0,0,0,1);"
        width="#{canvas.grid_size}" height="#{canvas.grid_size}"/>
      """

      result_square = Svg.square(canvas, sprite)

      assert result_square == expected_square
    end
  end

  describe "get_coordinate/1" do
    test "it gets an svg coordinate from a grid_coordinate" do
      canvas = Canvas.new()
      sprite = Enum.at(canvas.sprites, 0)

      expected_svg_coordinate = {(1-1)*canvas.grid_size, (1-1)*canvas.grid_size}

      coordinate = Svg.get_coordinate(canvas, sprite)

      assert coordinate == expected_svg_coordinate
    end
  end

end
