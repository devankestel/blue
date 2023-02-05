defmodule BlueWeb.BlueLive do
  use BlueWeb, :live_view

  alias Blue.{Canvas, Event, State}
  alias BlueWeb.{HeroComponent, DesignerModeComponent, SvgComponent}

  def mount(params, session, socket) do

    state = State.new()
    state = %{ state | canvas: create_starting_canvas()}
    IO.inspect(params)
    IO.inspect(session)

    {:ok, assign(
      socket,
      state: state
      )}
  end

  def create_starting_canvas() do
    Canvas.from_json("test/blue/fixtures/example_canvas.json")
  end

  def handle_event(event_name, event, socket) do
    case event_name do
      "svg_click" -> Event.svg_click(event, socket)
      "export" -> Event.export(socket)
      "designer_mode" -> Event.designer_mode(socket)
      "add_protagonist_sprite" -> Event.designer_mode_button(event_name, socket)
      "add_blue_item_sprite" -> Event.designer_mode_button(event_name, socket)
      "add_red_item_sprite" -> Event.designer_mode_button(event_name, socket)
      "add_wall_sprite" -> Event.designer_mode_button(event_name, socket)
      "delete_sprite" -> Event.designer_mode_button(event_name, socket)
      "keypress" -> Event.keypress(event, socket)
    end
  end

end
