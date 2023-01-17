defmodule Blue.SpriteTest do
    use ExUnit.Case
    alias Blue.Sprite

    describe "new/0" do
        test "creates a new sprite" do
            sprite = Sprite.new()

            assert sprite.grid_coordinate == {1, 1}
            assert sprite.color == :black
        end
    end

    describe "update_grid_coordinate/2" do
        test "up" do
            initial_grid_coordinate = {2, 2}
            expected_grid_coordinate = {2, 1}

            updated_grid_coordinate = Sprite.update_grid_coordinate(initial_grid_coordinate, :up)

            assert updated_grid_coordinate == expected_grid_coordinate
        end
        test "down" do
            initial_grid_coordinate = {1, 1}
            expected_grid_coordinate = {1, 2}

            updated_grid_coordinate = Sprite.update_grid_coordinate(initial_grid_coordinate, :down)

            assert updated_grid_coordinate == expected_grid_coordinate
        end
        test "left" do
            initial_grid_coordinate = {1, 1}
            expected_grid_coordinate = {0, 1}

            updated_grid_coordinate = Sprite.update_grid_coordinate(initial_grid_coordinate, :left)

            assert updated_grid_coordinate == expected_grid_coordinate
        end
        test "right" do
            initial_grid_coordinate = {1, 1}
            expected_grid_coordinate = {2, 1}

            updated_grid_coordinate = Sprite.update_grid_coordinate(initial_grid_coordinate, :right)

            assert updated_grid_coordinate == expected_grid_coordinate
        end
    end

    describe "move/2" do
        test "moves up" do
            sprite = Sprite.new()
            sprite = %{sprite | grid_coordinate: {2, 2}}
            expected_grid_coordinate = {2, 1}

            updated_sprite = Sprite.move(sprite, :up)

            assert updated_sprite.grid_coordinate == expected_grid_coordinate
            assert updated_sprite.color == :black
        end
    end

    describe "get_color_vector/1" do
        test "black" do
            sprite = Sprite.new()
            color_vector = Sprite.get_color_vector(sprite)

            assert color_vector == {0, 0, 0, 1}
        end
        test "red" do
            sprite = Sprite.new()
            sprite = %{sprite | color: :red}
            color_vector = Sprite.get_color_vector(sprite)

            assert color_vector == {255, 0, 0, 1}
        end
    end

end
