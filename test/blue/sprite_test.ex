defmodule Blue.SpriteTest do
    use ExUnit.Case
    alias Blue.Sprite

    describe "new/0" do
        test "creates a new sprite" do
            sprite = Sprite.new()

            assert sprite.position == {0, 0}
            assert sprite.color == :black
        end
    end

    describe "update_position/2" do
        test "up" do
            position = {1, 1}
            new_position = Sprite.update_position(position, :up)
            assert new_position == {1, 2}
        end
        test "down" do
            position = {1, 1}
            new_position = Sprite.update_position(position, :down)
            assert new_position == {1, 0} 
        end
        test "left" do
            position = {1, 1}
            new_position = Sprite.update_position(position, :left)
            assert new_position == {0, 1} 
        end
        test "right" do
            position = {1, 1}
            new_position = Sprite.update_position(position, :right)
            assert new_position == {2, 1}
        end
    end

    describe "move/2" do
        test "moves up" do
            sprite = Sprite.new()

            new_sprite = Sprite.move(sprite, :up)

            assert new_sprite.position == {0, 1}
            assert new_sprite.color == :black
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