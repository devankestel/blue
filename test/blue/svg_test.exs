defmodule Blue.SvgTest do
  use ExUnit.Case
  alias Blue.Canvas
  alias Blue.Sprite
  alias Blue.Svg

  describe "square/2" do
    test "it creates a black square" do
      canvas = Canvas.new()
      sprite = Sprite.new()
      sprite = %{sprite | grid_coordinate: {5, 5}}
      canvas = %{canvas | sprites: [sprite]}

      expected_square =
      """
      <rect
      x="80" y="80"
      style="fill:rgba(0,0,0,1);"
      width="#{canvas.grid_size}" height="#{canvas.grid_size}"/>
      """

      result_square = Svg.square(canvas, sprite)

      assert result_square == expected_square
    end
  end

  describe "get_coordinate/2" do
    test "it gets an svg coordinate from a grid_coordinate" do
      canvas = Canvas.new()
      sprite = Sprite.new()
      sprite = %{sprite | grid_coordinate: {5, 5}}
      canvas = %{canvas | sprites: [sprite]}

      expected_svg_coordinate = {(5-1)*canvas.grid_size, (5-1)*canvas.grid_size}

      coordinate = Svg.get_coordinate(canvas, sprite)

      assert coordinate == expected_svg_coordinate
    end
  end

  describe "get_grid_coordinate/2" do
    test "it gets an svg coordinate from a grid_coordinate" do
      canvas = Canvas.new()
      svg_coordinate = {25, 25}
      expected_grid_coordinate = {2, 2}

      grid_coordinate = Svg.get_grid_coordinate(svg_coordinate, canvas)

      assert grid_coordinate == expected_grid_coordinate
    end
  end

  describe "header/1" do
    test "creates svg header based on canvas params" do
      canvas = Canvas.new()
      expected_header =
        """
        <svg phx-click="svg_click"
        version="1.0"
        style="background-color: #F8F8F8"
        id="Layer_1"
        xmlns="http://www.w3.org/2000/svg"
        xmlns:xlink="http://www.w3.org/1999/xlink"
        width="200" height="400"
        viewBox="0 0 200 400"
        xml:space="preserve">
        """

      header = Svg.header(canvas)

      assert header == expected_header
    end
  end

  describe "footer/0" do
    test "creates svg header based on canvas params" do
      expected_footer = "</svg>"

      footer = Svg.footer()

      assert footer == expected_footer
    end
  end
end
