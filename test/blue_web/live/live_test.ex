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
end
