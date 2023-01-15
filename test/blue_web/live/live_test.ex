defmodule BlueWeb.BlueLiveTest do
  use ExUnit.Case
  alias BlueWeb.BlueLive
  alias Blue.Sprite

  describe "move/2" do
      test "moves one grid square right when not at edge of screen" do
          x = 20
          y = 20
          start_location = {x, y}

          expected_final_location = {BlueLive.grid_size + x, y}

          final_location = BlueLive.move(:right, start_location)

          assert final_location == expected_final_location
      end

      test "does not move right when at right edge of screen" do
        x = BlueLive.canvas_width - BlueLive.grid_size
        y = 20
        start_location = {x, y}

        final_location = BlueLive.move(:right, start_location)

        assert final_location == start_location
      end

      test "moves one grid square left when not at edge of screen" do
        x = 20
        y = 20

        start_location = {x, y}

        expected_final_location = {x - BlueLive.grid_size, y}

        final_location = BlueLive.move(:left, start_location)

        assert final_location == expected_final_location
      end

      test "does not move left when at left edge of screen" do
        x = 0
        y = 20
        start_location = {x, y}

        final_location = BlueLive.move(:left, start_location)

        assert final_location == start_location
      end
  end

  describe "is_at_edge?/1" do
    test "returns true when is at right edge" do
      x = BlueLive.canvas_width - BlueLive.grid_size
      y = 20
      start_location = {x, y}

      at_edge = BlueLive.is_at_edge?(:right, start_location)

      assert at_edge
    end
    test "returns true when is at left edge" do
      x = 0
      y = 20
      start_location = {x, y}

      at_edge = BlueLive.is_at_edge?(:left, start_location)

      assert at_edge
    end
  end

  describe "get_svg_coordinate/1" do
    test "it gets an svg_coordinate from a grid_coordinate" do
      sprite = Sprite.new()
      sprite = %{sprite | grid_coordinate: {5, 5}}

      expected_svg_coordinate = {(5-1)*BlueLive.grid_size, (5-1)*BlueLive.grid_size}

      svg_coordinate = BlueLive.get_svg_coordinate(sprite.grid_coordinate)

      assert svg_coordinate == expected_svg_coordinate
    end
  end

  describe "square/2" do
    test "it creates a black square" do
      location = {20, 20}
      color = "#000"

      expected_square =
      """
      <rect
        x="20" y="20"
        style="fill:#000;"
        width="#{BlueLive.grid_size}" height="#{BlueLive.grid_size}"/>
      """

      result_square = BlueLive.square(location, color)

      assert result_square == expected_square
    end
  end

  describe "squares" do

  end

  describe "mount/3" do

    test "assigns params to socket" do
      socket = %Phoenix.LiveView.Socket{}
      params = %{}
      session = nil

      {:ok, updated_socket} = BlueLive.mount(params, session, socket)

      assert updated_socket.assigns.sprite.grid_coordinate == {1, 1}
      assert updated_socket.assigns.sprite.color == :black

    end
  end

  describe "get_num_cols/0" do
    test "get number of columns on svg canvas" do
      num_cols = BlueLive.get_num_cols()
      expected_num_cols = BlueLive.canvas_width()/BlueLive.grid_size()

      assert num_cols == expected_num_cols
    end
  end

  describe "get_num_rows/0" do
    test "get number of rows on svg canvas" do
      num_rows = BlueLive.get_num_rows()
      expected_num_rows = BlueLive.canvas_height()/BlueLive.grid_size()

      assert num_rows == expected_num_rows
    end
  end

  describe "is_at_grid_edge/2" do
    test "returns true at left edge" do
      sprite = Sprite.new()

      at_edge? = BlueLive.is_at_grid_edge?(:left, sprite.grid_coordinate)

      assert at_edge? == true

    end

    test "returns true at right edge" do
      sprite = Sprite.new()
      sprite = %{sprite | grid_coordinate: {10, 1}}

      at_edge? = BlueLive.is_at_grid_edge?(:right, sprite.grid_coordinate)

      assert at_edge? == true
    end

    test "returns true at top edge" do
      sprite = Sprite.new()
      sprite = %{sprite | grid_coordinate: {10, 1}}

      at_edge? = BlueLive.is_at_grid_edge?(:up, sprite.grid_coordinate)

      assert at_edge? == true
    end

    test "returns true at bottom edge" do
      sprite = Sprite.new()
      sprite = %{sprite | grid_coordinate: {10, 20}}

      at_edge? = BlueLive.is_at_grid_edge?(:down, sprite.grid_coordinate)

      assert at_edge? == true
    end

    test "returns false on grid" do
      sprite = Sprite.new()
      sprite = %{sprite | grid_coordinate: {5, 5}}

      at_edge? = BlueLive.is_at_grid_edge?(:down, sprite.grid_coordinate)

      assert at_edge? == false
    end
  end

end
