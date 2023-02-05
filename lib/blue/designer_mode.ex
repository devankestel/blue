defmodule Blue.DesignerModeButtons do
  alias Blue.DesignerModeButtons
  defstruct [
    add_protagonist_sprite: false,
    add_red_item_sprite: false,
    add_blue_item_sprite: false,
    add_wall_sprite: false,
    delete_sprite: false,
  ]

  def new(), do: __struct__()

  def to_atom(button_name) do
    case button_name do
      "add_protagonist_sprite" -> :add_protagonist_sprite
      "add_red_item_sprite" -> :add_red_item_sprite
      "add_blue_item_sprite" -> :add_blue_item_sprite
      "add_wall_sprite" -> :add_wall_sprite
      "delete_sprite" -> :delete_sprite
      _ -> :no_match
    end
  end

  def toggle(buttons, button_name) do
    button_value = buttons |> Map.get(button_name)
    case button_value do
      true -> buttons |> toggle_off(button_name)
      false -> buttons |> toggle_on(button_name)
    end
  end

  def toggle_off(buttons, button_name) do
    buttons |> Map.put(button_name, false)
  end

  def toggle_on(buttons, button_name) do
    buttons_map = buttons
      |> Map.from_struct()
      |> Enum.map(fn ({k, _}) -> toggle_on_button(k, button_name) end)
      |> Map.new()

      struct(DesignerModeButtons, buttons_map)
  end

  def toggle_off_all(buttons) do
    buttons_map = buttons
      |> Map.from_struct()
      |> Enum.map(fn ({k, _}) -> {k, false} end)
      |> Map.new()

      struct(DesignerModeButtons, buttons_map)
  end

  def toggle_on_button(k, button_name) do
    case k do
      ^button_name -> {k, true}
      _ -> {k, false}
    end
  end
end


defmodule Blue.DesignerMode do
  alias Blue.DesignerModeButtons

  defstruct [
      on: false,
      buttons: DesignerModeButtons.new(),
  ]

  def new(), do: __struct__()

  def toggle(designer_mode) do
    case designer_mode.on do
      true -> %{
        designer_mode |
        on: false,
        buttons: DesignerModeButtons.toggle_off_all(designer_mode.buttons)
      }
      false -> %{designer_mode | on: true}
    end
  end

  def toggle_button(designer_mode, button_name) do
    case designer_mode.on do
      true -> %{
        designer_mode |
        buttons: DesignerModeButtons.toggle(designer_mode.buttons, button_name)
      }
      false -> designer_mode
    end
  end
end
