defmodule Blue.SpriteTest do
    use ExUnit.Case
    alias Blue.{Color, Sprite, Direction}

    describe "new/0" do
        test "creates a new sprite" do
            sprite = Sprite.new()

            assert sprite.grid_coordinate == {1, 1}
            assert sprite.color == :black
            assert sprite.type == :none
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

    describe "from_json/1" do
      test "changes json string into sprite struct" do
        path =   "test/blue/fixtures/example_sprite.json"

        expected_sprite = %Sprite{
          grid_coordinate: {5, 5},
          color: :black,
          type: :protagonist,
        }

        {:ok, sprite_contents} = File.read(path)
        sprite_json_string = Jason.decode!(sprite_contents)

        sprite = Sprite.from_json(sprite_json_string)

        assert sprite == expected_sprite

      end
    end

    describe "mapify/1" do
      test "changes sprite into map for encoding to json" do

        sprite = %Sprite{
          grid_coordinate: {5, 5},
          color: :black,
          type: :protagonist,
        }

        expected_sprite_map = %{
          grid_coordinate: %{
            col: 5,
            row: 5,
          },
          color: "black",
          type: "protagonist",
        }

        sprite_map = Sprite.mapify(sprite)

        assert sprite_map == expected_sprite_map

      end
    end

    describe "type_to_atom/1" do
      test "all the cases" do
        protagonist = Sprite.type_to_atom("protagonist")
        assert protagonist == :protagonist

        item = Sprite.type_to_atom("item")
        assert item == :item

        wall = Sprite.type_to_atom("wall")
        assert wall == :wall

        no_match = Sprite.type_to_atom("no_match")
        assert no_match == :none
      end
    end

    describe "from_key_to_atom/1" do
      test "gets all directions" do
        left = Direction.from_key_to_atom("ArrowLeft")
        assert left == :left
        right = Direction.from_key_to_atom("ArrowRight")
        assert right == :right
        up = Direction.from_key_to_atom("ArrowUp")
        assert up == :up
        down = Direction.from_key_to_atom("ArrowDown")
        assert down == :down
        no_match = Direction.from_key_to_atom("InvalidKey")
        assert no_match == :nomatch
      end
    end

    describe "Color.get_vector_string/1" do
      test "it gets black vector string" do
        color = :black
        expected_vector_string = "0,0,0,1"

        vector_string = Color.get_vector_string(color)

        assert vector_string == expected_vector_string
      end
      test "it gets red vector string" do
        color = :red
        expected_vector_string = "255,0,0,1"

        vector_string = Color.get_vector_string(color)

        assert vector_string == expected_vector_string
      end
      test "it gets green vector string" do
        color = :green
        expected_vector_string = "0,255,0,1"

        vector_string = Color.get_vector_string(color)

        assert vector_string == expected_vector_string
      end
      test "it gets blue vector string" do
        color = :blue
        expected_vector_string = "0,0,255,1"

        vector_string = Color.get_vector_string(color)

        assert vector_string == expected_vector_string
      end
      test "it gets white vector string" do
        color = :white
        expected_vector_string = "255,255,255,1"

        vector_string = Color.get_vector_string(color)

        assert vector_string == expected_vector_string
      end
      test "it gets gray vector string" do
        color = :gray
        expected_vector_string = "100,100,100,1"

        vector_string = Color.get_vector_string(color)

        assert vector_string == expected_vector_string
      end
    end

end
