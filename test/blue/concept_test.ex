defmodule Blue.ConceptTest do
    use ExUnit.Case
    alias Blue.Concept

    describe "new/0" do
        test "creates a new avatar" do
            avatar = Concept.new()

            assert avatar.position == {0, 0}
        end
    end

    describe "move/2" do
        test "moves up" do
            position = {1, 1}
            new_position = Concept.move(position, :up)
            assert new_position == {1, 2}
        end
        test "moves down" do
            position = {1, 1}
            new_position = Concept.move(position, :down)
            assert new_position == {1, 0} 
        end
        test "moves left" do
            position = {1, 1}
            new_position = Concept.move(position, :left)
            assert new_position == {0, 1} 
        end
        test "moves right" do
            position = {1, 1}
            new_position = Concept.move(position, :right)
            assert new_position == {2, 1}
        end
    end

    describe "move_avatar/2" do
        test "moves up" do
            avatar = Concept.new()

            new_avatar = Concept.move_avatar(avatar, :up)

            assert new_avatar.position == {0, 1}
        end
    end
end