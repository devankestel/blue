defmodule Blue.CanvasTest do
  use ExUnit.Case
  alias Blue.Canvas
  alias Blue.Sprite

  describe "new/0" do
    test "creates a new canvas" do
      canvas = Canvas.new()
      sprite1 = Sprite.new()
      sprite2 = Sprite.new()

      assert canvas.grid_size == 20
      assert canvas.width == 200
      assert canvas.height == 400
      assert canvas.sprites == [sprite1, sprite2]
    end
  end

  describe "get_num_cols/1" do
    test "get number of columns on svg canvas" do
      canvas = Canvas.new()
      num_cols = Canvas.get_num_cols(canvas)
      expected_num_cols = canvas.width/canvas.grid_size

      assert num_cols == expected_num_cols
    end
  end

  describe "get_num_rows/1" do
    test "get number of rows on svg canvas" do
      canvas = Canvas.new()
      num_rows = Canvas.get_num_rows(canvas)
      expected_num_rows = canvas.height/canvas.grid_size

      assert num_rows == expected_num_rows
    end
  end

  describe "is_at_grid_edge/2" do
    test "returns true at left edge" do
      sprite = Sprite.new()
      canvas = Canvas.new()

      at_edge? = Canvas.is_at_grid_edge?(canvas, :left, sprite.grid_coordinate)

      assert at_edge? == true

    end

    test "returns true at right edge" do
      sprite = Sprite.new()
      sprite = %{sprite | grid_coordinate: {10, 1}}

      canvas = Canvas.new()

      at_edge? = Canvas.is_at_grid_edge?(canvas, :right, sprite.grid_coordinate)

      assert at_edge? == true
    end

    test "returns true at top edge" do
      sprite = Sprite.new()
      sprite = %{sprite | grid_coordinate: {10, 1}}

      canvas = Canvas.new()

      at_edge? = Canvas.is_at_grid_edge?(canvas, :up, sprite.grid_coordinate)

      assert at_edge? == true
    end

    test "returns true at bottom edge" do
      sprite = Sprite.new()
      sprite = %{sprite | grid_coordinate: {10, 20}}

      canvas = Canvas.new()

      at_edge? = Canvas.is_at_grid_edge?(canvas, :down, sprite.grid_coordinate)

      assert at_edge? == true
    end

    test "returns false on grid" do
      sprite = Sprite.new()
      sprite = %{sprite | grid_coordinate: {5, 5}}

      canvas = Canvas.new()

      at_edge? = Canvas.is_at_grid_edge?(canvas, :down, sprite.grid_coordinate)

      assert at_edge? == false
    end
  end

end
