defmodule BlueWeb.BlueLiveTest do
  use ExUnit.Case
  alias BlueWeb.BlueLive
  alias Blue.{Canvas, Sprite}


  describe "mount/3" do

    test "assigns params to socket" do
      socket = %Phoenix.LiveView.Socket{}
      params = %{}
      session = nil

      {:ok, updated_socket} = BlueLive.mount(params, session, socket)

      updated_canvas = updated_socket.assigns.canvas
      assert updated_canvas.width == 200
      assert updated_canvas.height == 400
      assert updated_canvas.grid_size == 20
      assert Enum.at(updated_canvas.sprites, 0).color == :black
      assert Enum.at(updated_canvas.sprites, 1).color == :red

    end
  end

  describe "update_canvas/2" do
    test "move protagonist up" do
      canvas = Canvas.new()
      protagonist_sprite = %Sprite{
        grid_coordinate: {5, 5},
        type: :protagonist,
        color: :black
      }
      canvas = %{canvas | sprites: [protagonist_sprite]}
      key_pressed = "ArrowUp"

      {col, row} = protagonist_sprite.grid_coordinate
      expected_grid_coordinate = {col, row - 1}

      updated_canvas = BlueLive.update_canvas(key_pressed, canvas)

      updated_sprite = Enum.at(updated_canvas.sprites, 0)

      assert updated_sprite.grid_coordinate == expected_grid_coordinate

    end
    test "move protagonist down" do
      canvas = Canvas.new()
      protagonist_sprite = %Sprite{
        grid_coordinate: {5, 5},
        type: :protagonist,
        color: :black
      }
      canvas = %{canvas | sprites: [protagonist_sprite]}
      key_pressed = "ArrowDown"

      {col, row} = protagonist_sprite.grid_coordinate
      expected_grid_coordinate = {col, row + 1}

      updated_canvas = BlueLive.update_canvas(key_pressed, canvas)

      updated_sprite = Enum.at(updated_canvas.sprites, 0)

      assert updated_sprite.grid_coordinate == expected_grid_coordinate
    end
    test "move protagonist right" do
      canvas = Canvas.new()
      protagonist_sprite = %Sprite{
        grid_coordinate: {5, 5},
        type: :protagonist,
        color: :black
      }
      canvas = %{canvas | sprites: [protagonist_sprite]}
      key_pressed = "ArrowRight"

      {col, row} = protagonist_sprite.grid_coordinate
      expected_grid_coordinate = {col + 1, row}

      updated_canvas = BlueLive.update_canvas(key_pressed, canvas)

      updated_sprite = Enum.at(updated_canvas.sprites, 0)

      assert updated_sprite.grid_coordinate == expected_grid_coordinate
    end
    test "move_protagonist left" do
      canvas = Canvas.new()
      protagonist_sprite = %Sprite{
        grid_coordinate: {5, 5},
        type: :protagonist,
        color: :black
      }
      canvas = %{canvas | sprites: [protagonist_sprite]}
      key_pressed = "ArrowLeft"

      {col, row} = protagonist_sprite.grid_coordinate
      expected_grid_coordinate = {col - 1, row}

      updated_canvas = BlueLive.update_canvas(key_pressed, canvas)

      updated_sprite = Enum.at(updated_canvas.sprites, 0)

      assert updated_sprite.grid_coordinate == expected_grid_coordinate
    end
  end

  describe "get_direction/1" do
    test "gets all directions" do
      left = BlueLive.get_direction("ArrowLeft")
      assert left == :left
      right = BlueLive.get_direction("ArrowRight")
      assert right == :right
      up = BlueLive.get_direction("ArrowUp")
      assert up == :up
      down = BlueLive.get_direction("ArrowDown")
      assert down == :down
      no_match = BlueLive.get_direction("InvalidKey")
      assert no_match == :nomatch
    end
  end

end
