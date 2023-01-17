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
      sprite = Sprite.new()
      sprite = %{sprite | grid_coordinate: {5, 5}}
      canvas = %{canvas | sprites: [sprite]}
      key_pressed = "ArrowUp"

      {col, row} = sprite.grid_coordinate
      expected_grid_coordinate = {col, row - 1}

      updated_canvas = BlueLive.update_canvas(key_pressed, canvas)

      updated_sprite = Enum.at(updated_canvas.sprites, 0)

      assert updated_sprite.grid_coordinate == expected_grid_coordinate

    end
    test "move protagonist down" do
      canvas = Canvas.new()
      sprite = Sprite.new()
      sprite = %{sprite | grid_coordinate: {5, 5}}
      canvas = %{canvas | sprites: [sprite]}
      key_pressed = "ArrowDown"

      {col, row} = sprite.grid_coordinate
      expected_grid_coordinate = {col, row + 1}

      updated_canvas = BlueLive.update_canvas(key_pressed, canvas)

      updated_sprite = Enum.at(updated_canvas.sprites, 0)

      assert updated_sprite.grid_coordinate == expected_grid_coordinate
    end
    test "move protagonist right" do
      canvas = Canvas.new()
      sprite = Sprite.new()
      sprite = %{sprite | grid_coordinate: {5, 5}}
      canvas = %{canvas | sprites: [sprite]}
      key_pressed = "ArrowRight"

      {col, row} = sprite.grid_coordinate
      expected_grid_coordinate = {col + 1, row}

      updated_canvas = BlueLive.update_canvas(key_pressed, canvas)

      updated_sprite = Enum.at(updated_canvas.sprites, 0)

      assert updated_sprite.grid_coordinate == expected_grid_coordinate
    end
    test "move_protagonist left" do
      canvas = Canvas.new()
      sprite = Sprite.new()
      sprite = %{sprite | grid_coordinate: {5, 5}}
      canvas = %{canvas | sprites: [sprite]}
      key_pressed = "ArrowLeft"

      {col, row} = sprite.grid_coordinate
      expected_grid_coordinate = {col - 1, row}

      updated_canvas = BlueLive.update_canvas(key_pressed, canvas)

      updated_sprite = Enum.at(updated_canvas.sprites, 0)

      assert updated_sprite.grid_coordinate == expected_grid_coordinate
    end
  end

end
