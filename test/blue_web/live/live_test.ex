defmodule BlueWeb.BlueLiveTest do
  use ExUnit.Case
  alias BlueWeb.BlueLive

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

  describe "get_location/1" do
    test "it gets a location from a grid position" do
      position = {5, 5}

      expected_location = {(5-1)*BlueLive.grid_size, (5-1)*BlueLive.grid_size}

      location = BlueLive.get_location(position)

      assert location == expected_location
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

end
