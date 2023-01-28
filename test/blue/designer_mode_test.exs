defmodule Blue.DesignerModeTest do
  use ExUnit.Case
  alias Blue.{DesignerMode, DesignerModeButtons}

  describe "DesignerMode.new/0" do
    test "creates a new designer mode" do
      designer_mode = DesignerMode.new()

      assert designer_mode.on == false
      assert designer_mode.buttons.add_protagonist_sprite == false
      assert designer_mode.buttons.add_red_item_sprite == false
      assert designer_mode.buttons.add_blue_item_sprite == false
      assert designer_mode.buttons.add_wall_sprite == false
      assert designer_mode.buttons.delete_sprite == false
    end
  end

  describe "DesignerMode.toggle/1" do
    test "it toggles on designer mode" do
      designer_mode = DesignerMode.new()

      expected_designer_mode = %{designer_mode | on: true}

      updated_designer_mode = DesignerMode.toggle(designer_mode)

      assert updated_designer_mode == expected_designer_mode
    end
    test "it toggles off designer mode and all buttons" do
      buttons = %DesignerModeButtons{
        add_protagonist_sprite: true,
        add_red_item_sprite: true,
        add_blue_item_sprite: true,
        add_wall_sprite: true,
        delete_sprite: true,
      }

      designer_mode = %DesignerMode{
        on: true,
        buttons: buttons
      }

      expected_buttons = %DesignerModeButtons{
        add_protagonist_sprite: false,
        add_red_item_sprite: false,
        add_blue_item_sprite: false,
        add_wall_sprite: false,
        delete_sprite: false,
      }

      expected_designer_mode = %DesignerMode{
        on: false,
        buttons: expected_buttons,
      }

      updated_designer_mode = DesignerMode.toggle(designer_mode)

      assert updated_designer_mode == expected_designer_mode
    end
  end

  describe "DesignerModeButtons.toggle/2" do
    test "it toggles a button off" do
      buttons = DesignerModeButtons.new()
      buttons = %{buttons | add_protagonist_sprite: true}

      # all buttons are false
      expected_buttons = DesignerModeButtons.new()

      updated_buttons = DesignerModeButtons.toggle(buttons, :add_protagonist_sprite)

      assert updated_buttons == expected_buttons
    end
    test "it toggles a button on, and turns all other buttons off" do
      buttons = DesignerModeButtons.new()
      buttons = %{buttons | add_blue_item_sprite: true}

      # all buttons are false
      expected_buttons = DesignerModeButtons.new()
      expected_buttons = %{expected_buttons | add_protagonist_sprite: true}

      updated_buttons = DesignerModeButtons.toggle_on(buttons, :add_protagonist_sprite)

      assert updated_buttons == expected_buttons
    end
  end

  describe "DesignerModeButtons.toggle_off/2" do
    test "it toggles a button off" do
      buttons = DesignerModeButtons.new()
      buttons = %{buttons | add_protagonist_sprite: true}

      # all buttons are false
      expected_buttons = DesignerModeButtons.new()

      updated_buttons = DesignerModeButtons.toggle_off(buttons, :add_protagonist_sprite)

      assert updated_buttons == expected_buttons
    end
  end
  describe "DesignerModeButtons.toggle_on/2" do
    test "it toggles a button on, and turns all other buttons off" do
      buttons = DesignerModeButtons.new()
      buttons = %{buttons | add_blue_item_sprite: true}

      # all buttons are false
      expected_buttons = DesignerModeButtons.new()
      expected_buttons = %{expected_buttons | add_protagonist_sprite: true}

      updated_buttons = DesignerModeButtons.toggle(buttons, :add_protagonist_sprite)

      assert updated_buttons == expected_buttons
    end
  end

  describe "DesignerModeButtons.toggle_on_button/2" do
    test "it toggles a button on, when the button name matches" do
      k = :add_protagonist_sprite
      button_name = :add_protagonist_sprite

      expected_pair = {k, true}

      pair = DesignerModeButtons.toggle_on_button(k, button_name)

      assert pair == expected_pair
    end
    test "it toggles a button off, when the name does not match" do
      k = :add_protagonist_sprite
      button_name = :delete_sprite

      expected_pair = {k, false}

      pair = DesignerModeButtons.toggle_on_button(k, button_name)

      assert pair == expected_pair
    end
  end

  describe "DesignerModeButtons.toggle_off_all" do
    test "it toggles off all buttons" do
      buttons = %DesignerModeButtons{
        add_protagonist_sprite: true,
        add_red_item_sprite: true,
        add_blue_item_sprite: true,
        add_wall_sprite: true,
        delete_sprite: true,
      }

      expected_buttons = %DesignerModeButtons{
        add_protagonist_sprite: false,
        add_red_item_sprite: false,
        add_blue_item_sprite: false,
        add_wall_sprite: false,
        delete_sprite: false,
      }

      updated_buttons = DesignerModeButtons.toggle_off_all(buttons)

      assert updated_buttons == expected_buttons
    end
  end
end
