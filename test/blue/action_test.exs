defmodule Blue.SpriteTest do
    use ExUnit.Case
    alias Blue.{Action, Canvas, Sprite}

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
end
