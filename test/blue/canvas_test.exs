defmodule Blue.CanvasTest do
  use ExUnit.Case
  alias Blue.Canvas
  alias Blue.Sprite

  describe "new/0" do
    test "creates a new canvas" do
      canvas = Canvas.new()

      assert canvas.grid_size == 20
      assert canvas.width == 200
      assert canvas.height == 400
      assert canvas.sprites == []
    end
  end

  describe "get_num_cols/1" do
    test "get number of columns on svg canvas" do
      canvas = Canvas.new()
      num_cols = Canvas.get_num_cols(canvas)
      expected_num_cols = canvas.width/canvas.grid_size

      assert num_cols == expected_num_cols
    end
  end

  describe "get_num_rows/1" do
    test "get number of rows on svg canvas" do
      canvas = Canvas.new()
      num_rows = Canvas.get_num_rows(canvas)
      expected_num_rows = canvas.height/canvas.grid_size

      assert num_rows == expected_num_rows
    end
  end

  describe "is_at_grid_edge?/2" do
    test "returns true at left edge" do
      sprite = Sprite.new()
      canvas = Canvas.new()

      at_edge? = Canvas.is_at_grid_edge?(canvas, :left, sprite.grid_coordinate)

      assert at_edge? == true

    end

    test "returns true at right edge" do
      sprite = Sprite.new()
      sprite = %{sprite | grid_coordinate: {10, 1}}

      canvas = Canvas.new()

      at_edge? = Canvas.is_at_grid_edge?(canvas, :right, sprite.grid_coordinate)

      assert at_edge? == true
    end

    test "returns true at top edge" do
      sprite = Sprite.new()
      sprite = %{sprite | grid_coordinate: {10, 1}}

      canvas = Canvas.new()

      at_edge? = Canvas.is_at_grid_edge?(canvas, :up, sprite.grid_coordinate)

      assert at_edge? == true
    end

    test "returns true at bottom edge" do
      sprite = Sprite.new()
      sprite = %{sprite | grid_coordinate: {10, 20}}

      canvas = Canvas.new()

      at_edge? = Canvas.is_at_grid_edge?(canvas, :down, sprite.grid_coordinate)

      assert at_edge? == true
    end

    test "returns false on grid" do
      sprite = Sprite.new()
      sprite = %{sprite | grid_coordinate: {5, 5}}

      canvas = Canvas.new()

      at_edge? = Canvas.is_at_grid_edge?(canvas, :down, sprite.grid_coordinate)

      assert at_edge? == false
    end
  end

  describe "can_collect_item?/3" do
    test "returns true with item to the left" do
      protagonist = Sprite.new()
      protagonist = %{protagonist | grid_coordinate: {2, 1}}
      item = Sprite.new()
      item = %{item | grid_coordinate: {1, 1}}
      canvas = Canvas.new()
      canvas = %{canvas | sprites: [protagonist, item]}

      collect_item? = Canvas.can_collect_item?(:left, protagonist.grid_coordinate, item.grid_coordinate)

      assert collect_item? == true

    end

    test "returns true with item to the right" do
      protagonist = Sprite.new()
      protagonist = %{protagonist | grid_coordinate: {2, 1}}
      item = Sprite.new()
      item = %{item | grid_coordinate: {3, 1}}
      canvas = Canvas.new()
      canvas = %{canvas | sprites: [protagonist, item]}

      collect_item? = Canvas.can_collect_item?(:right, protagonist.grid_coordinate, item.grid_coordinate)

      assert collect_item? == true
    end

    test "returns true with item above" do
      protagonist = Sprite.new()
      protagonist = %{protagonist | grid_coordinate: {1, 2}}
      item = Sprite.new()
      item = %{item | grid_coordinate: {1, 1}}
      canvas = Canvas.new()
      canvas = %{canvas | sprites: [protagonist, item]}

      collect_item? = Canvas.can_collect_item?(:up, protagonist.grid_coordinate, item.grid_coordinate)

      assert collect_item? == true
    end

    test "returns true with item below" do
      protagonist = Sprite.new()
      protagonist = %{protagonist | grid_coordinate: {1, 1}}
      item = Sprite.new()
      item = %{item | grid_coordinate: {1, 2}}
      canvas = Canvas.new()
      canvas = %{canvas | sprites: [protagonist, item]}

      collect_item? = Canvas.can_collect_item?(:down, protagonist.grid_coordinate, item.grid_coordinate)

      assert collect_item? == true
    end

    test "returns false when not next to item" do
      protagonist = Sprite.new()
      protagonist = %{protagonist | grid_coordinate: {1, 1}}
      item = Sprite.new()
      item = %{item | grid_coordinate: {5, 5}}
      canvas = Canvas.new()
      canvas = %{canvas | sprites: [protagonist, item]}

      collect_item? = Canvas.can_collect_item?(:down, protagonist.grid_coordinate, item.grid_coordinate)

      assert collect_item? == false
    end
  end

  describe "has_item/1" do
    test "it returns true when an item is present in the sprite list" do
      canvas = Canvas.new()
      sprite1 = Sprite.new()
      sprite2 = Sprite.new()
      sprite2 = %{sprite2 | grid_coordinate: {5, 5}}
      sprite2 = %{sprite2 | color: :red}
      canvas = %{canvas | sprites: [sprite1, sprite2]}

      item? = Canvas.has_item?(canvas)

      assert item? == true
    end
    test "it returns false when no item is present in the sprite list" do
      canvas = Canvas.new()
      sprite1 = Sprite.new()

      canvas = %{canvas | sprites: [sprite1]}

      item? = Canvas.has_item?(canvas)

      assert item? == false
    end
    test "it returns true when more than one item is present" do
      canvas = Canvas.new()
      sprite1 = Sprite.new()
      sprite2 = Sprite.new()
      sprite2 = %{sprite2 | grid_coordinate: {5, 5}}
      sprite2 = %{sprite2 | color: :red}
      sprite3 = Sprite.new()
      sprite3 = %{sprite3 | grid_coordinate: {6, 7}}
      sprite3 = %{sprite3 | color: :red}

      canvas = %{canvas | sprites: [sprite1, sprite2, sprite3]}

      item? = Canvas.has_item?(canvas)

      assert item? == true
    end
  end
  describe "get_sprites_by_type/2" do
    test "gets items from sprites list" do
      canvas = Canvas.new()
      protagonist_sprite = Sprite.new()
      protagonist_sprite = %{protagonist_sprite | type: :protagonist}
      item1_sprite = Sprite.new()
      item1_sprite = %{item1_sprite | grid_coordinate: {5, 5}}
      item1_sprite = %{item1_sprite | color: :red}
      item1_sprite = %{item1_sprite | type: :item}
      item2_sprite = Sprite.new()
      item2_sprite = %{item2_sprite | grid_coordinate: {6, 7}}
      item2_sprite = %{item2_sprite | color: :red}
      item2_sprite = %{item2_sprite | type: :item}

      canvas = %{canvas | sprites: [protagonist_sprite, item1_sprite, item2_sprite]}

      item_sprites = Canvas.get_sprites_by_type(canvas, :item)

      assert item_sprites == [item1_sprite, item2_sprite]
    end
  end

  describe "remove_sprite/2" do
    test "remove the second sprite" do
      canvas = Canvas.new()
      sprite1 = Sprite.new()
      sprite2 = Sprite.new()
      sprite2 = %{sprite2 | grid_coordinate: {5, 5}}
      sprite2 = %{sprite2 | color: :red}
      sprite3 = Sprite.new()
      sprite3 = %{sprite3 | grid_coordinate: {6, 7}}
      sprite3 = %{sprite3 | color: :red}

      canvas = %{canvas | sprites: [sprite1, sprite2, sprite3]}

      updated_canvas = Canvas.remove_sprite(canvas, sprite2)

      assert Enum.count(updated_canvas.sprites) == Enum.count(canvas.sprites) - 1
      # No sprites left on canvas have coordinate of removed sprite
      # This assumes that no 2 sprites can occupy the same space on a canvas
      assert Enum.all?(updated_canvas.sprites, fn s -> s.grid_coordinate != sprite2.grid_coordinate end)
    end
  end

  describe "has adjacent sprite/2" do
    test "has adjacent sprite to the left" do
      protagonist_sprite = Sprite.new()
      protagonist_sprite = %{protagonist_sprite | grid_coordinate: {2, 1}}
      protagonist_sprite = %{protagonist_sprite | type: :protagonist}
      item_sprite = Sprite.new()
      item_sprite = %{item_sprite | grid_coordinate: {1, 1}}
      item_sprite = %{item_sprite | type: :item}
      canvas = Canvas.new()
      canvas = %{canvas | sprites: [protagonist_sprite, item_sprite]}

      adjacent_sprite? = Canvas.has_adjacent_sprite?(canvas, :left, protagonist_sprite.grid_coordinate)

      assert adjacent_sprite? == true
    end
    test "has adjacent sprite to the right" do
      protagonist_sprite = Sprite.new()
      protagonist_sprite = %{protagonist_sprite | grid_coordinate: {2, 1}}
      protagonist_sprite = %{protagonist_sprite | type: :protagonist}
      item_sprite = Sprite.new()
      item_sprite = %{item_sprite | grid_coordinate: {3, 1}}
      item_sprite = %{item_sprite | type: :item}
      canvas = Canvas.new()
      canvas = %{canvas | sprites: [protagonist_sprite, item_sprite]}

      adjacent_sprite? = Canvas.has_adjacent_sprite?(canvas, :right, protagonist_sprite.grid_coordinate)

      assert adjacent_sprite? == true
    end
    test "has adjacent sprite above" do
      protagonist_sprite = Sprite.new()
      protagonist_sprite = %{protagonist_sprite | grid_coordinate: {2, 2}}
      protagonist_sprite = %{protagonist_sprite | type: :protagonist}
      item_sprite = Sprite.new()
      item_sprite = %{item_sprite | grid_coordinate: {2, 1}}
      item_sprite = %{item_sprite | type: :item}
      canvas = Canvas.new()
      canvas = %{canvas | sprites: [protagonist_sprite, item_sprite]}

      adjacent_sprite? = Canvas.has_adjacent_sprite?(canvas, :up, protagonist_sprite.grid_coordinate)

      assert adjacent_sprite? == true
    end
    test "has adjacent sprite below" do
      protagonist_sprite = Sprite.new()
      protagonist_sprite = %{protagonist_sprite | grid_coordinate: {2, 1}}
      protagonist_sprite = %{protagonist_sprite | type: :protagonist}
      item_sprite = Sprite.new()
      item_sprite = %{item_sprite | grid_coordinate: {2, 2}}
      item_sprite = %{item_sprite | type: :item}
      canvas = Canvas.new()
      canvas = %{canvas | sprites: [protagonist_sprite, item_sprite]}

      adjacent_sprite? = Canvas.has_adjacent_sprite?(canvas, :down, protagonist_sprite.grid_coordinate)

      assert adjacent_sprite? == true
    end
  end

  describe "get adjacent sprite/2" do
    test "get adjacent sprite to the left" do
      protagonist_sprite = Sprite.new()
      protagonist_sprite = %{protagonist_sprite | grid_coordinate: {2, 1}}
      protagonist_sprite = %{protagonist_sprite | type: :protagonist}
      item_sprite = Sprite.new()
      item_sprite = %{item_sprite | grid_coordinate: {1, 1}}
      item_sprite = %{item_sprite | type: :item}
      canvas = Canvas.new()
      canvas = %{canvas | sprites: [protagonist_sprite, item_sprite]}

      adjacent_sprite = Canvas.get_adjacent_sprite(canvas, :left, protagonist_sprite.grid_coordinate)

      assert adjacent_sprite == item_sprite
    end
    test "get adjacent sprite to the right" do
      protagonist_sprite = Sprite.new()
      protagonist_sprite = %{protagonist_sprite | grid_coordinate: {2, 1}}
      protagonist_sprite = %{protagonist_sprite | type: :protagonist}
      item_sprite = Sprite.new()
      item_sprite = %{item_sprite | grid_coordinate: {3, 1}}
      item_sprite = %{item_sprite | type: :item}
      canvas = Canvas.new()
      canvas = %{canvas | sprites: [protagonist_sprite, item_sprite]}

      adjacent_sprite = Canvas.get_adjacent_sprite(canvas, :right, protagonist_sprite.grid_coordinate)

      assert adjacent_sprite == item_sprite
    end
    test "get adjacent sprite above" do
      protagonist_sprite = Sprite.new()
      protagonist_sprite = %{protagonist_sprite | grid_coordinate: {2, 2}}
      protagonist_sprite = %{protagonist_sprite | type: :protagonist}
      item_sprite = Sprite.new()
      item_sprite = %{item_sprite | grid_coordinate: {2, 1}}
      item_sprite = %{item_sprite | type: :item}
      canvas = Canvas.new()
      canvas = %{canvas | sprites: [protagonist_sprite, item_sprite]}

      adjacent_sprite = Canvas.get_adjacent_sprite(canvas, :up, protagonist_sprite.grid_coordinate)

      assert adjacent_sprite == item_sprite
    end
    test "has adjacent sprite below" do
      protagonist_sprite = Sprite.new()
      protagonist_sprite = %{protagonist_sprite | grid_coordinate: {2, 1}}
      protagonist_sprite = %{protagonist_sprite | type: :protagonist}
      item_sprite = Sprite.new()
      item_sprite = %{item_sprite | grid_coordinate: {2, 2}}
      item_sprite = %{item_sprite | type: :item}
      canvas = Canvas.new()
      canvas = %{canvas | sprites: [protagonist_sprite, item_sprite]}

      adjacent_sprite = Canvas.get_adjacent_sprite(canvas, :down, protagonist_sprite.grid_coordinate)

      assert adjacent_sprite == item_sprite
    end
  end

  describe "move_sprite/3" do
    test "move the first sprite" do
      canvas = Canvas.new()
      sprite1 = Sprite.new()
      sprite2 = Sprite.new()
      sprite2 = %{sprite2 | grid_coordinate: {5, 5}}
      sprite2 = %{sprite2 | color: :red}
      sprite3 = Sprite.new()
      sprite3 = %{sprite3 | grid_coordinate: {6, 7}}
      sprite3 = %{sprite3 | color: :red}

      canvas = %{canvas | sprites: [sprite1, sprite2, sprite3]}

      {col, row} = sprite1.grid_coordinate
      expected_grid_coordinate = {col + 1, row}

      updated_canvas = Canvas.move_sprite(canvas, sprite1, :right)

      assert Enum.count(updated_canvas.sprites) == Enum.count(canvas.sprites)
      assert Enum.at(updated_canvas.sprites, 1) == Enum.at(canvas.sprites, 1)
      assert Enum.at(updated_canvas.sprites, 2) == Enum.at(canvas.sprites, 2)

      assert Enum.at(updated_canvas.sprites, 0).grid_coordinate == expected_grid_coordinate

    end
  end

  describe "render/2" do
    test "it renders a full svg, header, footer, and sprites" do
      canvas = Canvas.new()
      sprite1 = Sprite.new()
      sprite2 = Sprite.new()
      sprite2 = %{sprite2 | grid_coordinate: {5, 5}}
      sprite2 = %{sprite2 | color: :red}
      canvas = %{canvas | sprites: [sprite1, sprite2]}

      expected_svg =
        """
        <svg
        version="1.0"
        style="background-color: #F8F8F8"
        id="Layer_1"
        xmlns="http://www.w3.org/2000/svg"
        xmlns:xlink="http://www.w3.org/1999/xlink"
        width="200" height="400"
        viewBox="0 0 200 400"
        xml:space="preserve">
        <rect
        x="0" y="0"
        style="fill:rgba(0,0,0,1);"
        width="20" height="20"/>
        <rect
        x="80" y="80"
        style="fill:rgba(255,0,0,1);"
        width="20" height="20"/>
        </svg>\
        """

        svg = Canvas.render(canvas)

        assert svg == expected_svg
    end
  end

  describe "from_json/1" do
    result = Canvas.from_json("test/blue/fixtures/example_canvas.json")

    assert result == "poop"
  end
end
