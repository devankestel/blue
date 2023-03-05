defmodule Blue.ActionTest do
  use ExUnit.Case
  use Patch
  alias Blue.{Action, Canvas, Direction, Sprite}

  # @TODO: as this module stands almost everything is an integration test
  # These need to be turned into proper unit tests at some point

  describe "add_sprite/3" do
    test "it adds a sprite" do
      color = :blue
      grid_coordinate = {5, 5}
      type = :item

      canvas = Canvas.new()

      updated_canvas = Action.add_sprite(grid_coordinate, type, color, canvas)

      [added_sprite | _] = updated_canvas.sprites
      assert added_sprite.color == color
      assert added_sprite.grid_coordinate == grid_coordinate
      assert added_sprite.type == type
    end
  end

  describe "handle_wall_sprite/1" do
    test "protagonist doesn't move when it hits a wall" do
      canvas = Canvas.new()
      protagonist_sprite = %Sprite{
        type: :protagonist,
        color: :black,
        grid_coordinate: {5, 5}
      }
      wall_sprite = %Sprite{
        type: :wall,
        color: :gray,
        grid_coordinate: {5, 6}
      }
      canvas = %{canvas | sprites: [protagonist_sprite, wall_sprite]}

      expected_canvas = canvas

      updated_canvas = Action.handle_wall_sprite(canvas)

      assert updated_canvas == expected_canvas
    end
  end

  describe "handle_item_sprite/1" do
    test "protagonist picks up item" do
      canvas = Canvas.new()
      protagonist_sprite = %Sprite{
        type: :protagonist,
        color: :black,
        grid_coordinate: {5, 5}
      }
      item_sprite = %Sprite{
        type: :wall,
        color: :blue,
        grid_coordinate: {5, 6}
      }
      canvas = %{canvas | sprites: [protagonist_sprite, item_sprite]}
      direction = :down

      moved_protagonist_sprite = %{protagonist_sprite | grid_coordinate: {5, 6}}
      expected_canvas = %{canvas | sprites: [moved_protagonist_sprite]}

      updated_canvas = Action.handle_item_sprite(canvas, direction, protagonist_sprite, item_sprite)

      assert updated_canvas == expected_canvas
    end
  end

  describe "update_canavs/2" do
    # @TODO: parameterize this test
    test "it moves protagonist up" do
      expected_protagonist_grid_coordinate = {5, 4}
      key_pressed = "ArrowUp"
      direction = :up
      test_update_canvas(key_pressed, direction, expected_protagonist_grid_coordinate)
    end
    test "it moves protagonist down" do
      expected_protagonist_grid_coordinate = {5, 6}
      key_pressed = "ArrowDown"
      direction = :down
      test_update_canvas(key_pressed, direction, expected_protagonist_grid_coordinate)
    end
    test "it moves protagonist left" do
      expected_protagonist_grid_coordinate = {4, 5}
      key_pressed = "ArrowLeft"
      direction = :left
      test_update_canvas(key_pressed, direction, expected_protagonist_grid_coordinate)
    end
    test "it moves protagonist right" do
      expected_protagonist_grid_coordinate = {6, 5}
      key_pressed = "ArrowRight"
      direction = :right
      test_update_canvas(key_pressed, direction, expected_protagonist_grid_coordinate)
    end
    test "it does not move when a non-arrow key is pressed" do
      key_pressed = "NotAnArrowKey"
      canvas = Canvas.new()
      protagonist_sprite = %Sprite{
        type: :protagonist,
        color: :black,
        grid_coordinate: {5, 5}
      }
      canvas = %{canvas | sprites: [protagonist_sprite]}
      expected_canvas = canvas
      direction = :nomatch
      patch(Direction, :from_key_to_atom, direction)
      patch(Action, :move_protagonist, expected_canvas)

      updated_canvas = Action.update_canvas(key_pressed, canvas)

      assert updated_canvas == expected_canvas
      assert_called Direction.from_key_to_atom(key_pressed), 1
      refute_called Action.move_protagonist(direction, canvas)
    end
  end

  describe "update_canvas_designer_mode/2" do
  end

  describe "add_protagonist_sprite/3" do
  end

  describe "delete_sprite/2" do
  end

  describe "remove_protagonist/1" do
  end

  describe "move_protagonist/2" do
  end

  describe "handle_adjacent_sprite/3" do
    test "it collects an adjacent item sprite" do
      canvas = Canvas.new()
      protagonist_sprite = %Sprite{
        type: :protagonist,
        color: :black,
        grid_coordinate: {5, 5}
      }
      item_sprite = %Sprite{
        type: :item,
        color: :blue,
        grid_coordinate: {5, 6}
      }
      direction = :right
      protagonist_grid_coordinate = protagonist_sprite.grid_coordinate

      canvas = %{canvas | sprites: [protagonist_sprite, item_sprite]}

      expected_protagonist_grid_coordinate = {5, 6}
      moved_protagonist_sprite = %{protagonist_sprite | grid_coordinate: expected_protagonist_grid_coordinate}
      expected_canvas = %{canvas | sprites: [moved_protagonist_sprite]}

      patch(Canvas, :get_adjacent_sprite, item_sprite)
      patch(Action, :handle_item_sprite, expected_canvas)
      patch(Action, :handle_wall_sprite, nil)

      updated_canvas = Action.handle_adjacent_sprite(canvas, direction, protagonist_sprite)

      assert updated_canvas == expected_canvas
      assert_called Canvas.get_adjacent_sprite(canvas, direction, protagonist_grid_coordinate), 1
      assert_called Action.handle_item_sprite(canvas, direction, protagonist_sprite, item_sprite), 1
      refute_called Action.handle_wall_sprite(canvas)
    end
    test "it stops when a wall is in the way" do
      canvas = Canvas.new()
      protagonist_sprite = %Sprite{
        type: :protagonist,
        color: :black,
        grid_coordinate: {5, 5}
      }
      wall_sprite = %Sprite{
        type: :wall,
        color: :gray,
        grid_coordinate: {5, 6}
      }
      direction = :right
      protagonist_grid_coordinate = protagonist_sprite.grid_coordinate

      canvas = %{canvas | sprites: [protagonist_sprite, wall_sprite]}

      expected_canvas = canvas

      patch(Canvas, :get_adjacent_sprite, wall_sprite)
      patch(Action, :handle_item_sprite, nil)
      patch(Action, :handle_wall_sprite, expected_canvas)

      updated_canvas = Action.handle_adjacent_sprite(canvas, direction, protagonist_sprite)

      assert updated_canvas == expected_canvas
      assert_called Canvas.get_adjacent_sprite(canvas, direction, protagonist_grid_coordinate), 1
      assert_called Action.handle_wall_sprite(canvas), 1
      refute_called Action.handle_item_sprite(canvas, direction, protagonist_sprite, item_sprite)
    end
  end


  def test_update_canvas(key_pressed, direction, expected_protagonist_grid_coordinate) do
    canvas = Canvas.new()
    protagonist_sprite = %Sprite{
      type: :protagonist,
      color: :black,
      grid_coordinate: {5, 5}
    }
    canvas = %{canvas | sprites: [protagonist_sprite]}

    moved_protagonist_sprite = %{protagonist_sprite | grid_coordinate: expected_protagonist_grid_coordinate}
    expected_canvas = %{canvas | sprites: [moved_protagonist_sprite]}

    patch(Direction, :from_key_to_atom, direction)
    patch(Action, :move_protagonist, expected_canvas)

    updated_canvas = Action.update_canvas(key_pressed, canvas)

    assert updated_canvas == expected_canvas
    assert_called Direction.from_key_to_atom(key_pressed), 1
    assert_called Action.move_protagonist(direction, canvas), 1
  end

end
