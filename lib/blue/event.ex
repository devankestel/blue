defmodule Blue.Event do
  alias Blue.DesignerModeButtons
  alias Blue.{Action, Canvas, DesignerMode}
  alias Phoenix.Socket

  def svg_click( %{"offsetX" => x, "offsetY" => y} = _event, socket) do
    case socket.assigns.state.designer_mode.on do
      true -> Action.update_canvas_designer_mode({x, y}, socket)
      false -> {:noreply, socket}
    end
  end

  def inc(socket) do
    {:noreply, Socket.update(socket, :val, &(&1 + 1))}
  end

  def export(socket) do
    IO.inspect(socket.assigns.state.filename)
    Canvas.to_json(socket.assigns.state.canvas, "lib/blue_web/live/json_exports/export_canvas.json")
    {:noreply, socket}
  end

  def designer_mode(socket) do
    IO.inspect(socket.assigns.state)
    {:noreply,
    Socket.assign(
      socket,
      state: %{
        socket.assigns.state |
        designer_mode: DesignerMode.toggle(socket.assigns.state.designer_mode)
      }
    )
    }
  end

  def designer_mode_button(event_name, socket) do

    button_name = DesignerModeButtons.to_atom(event_name)

    IO.inspect(socket.assigns.state)
    designer_mode = socket.assigns.state.designer_mode
    {:noreply,
    Socket.assign(
      socket,
      state: %{
        socket.assigns.state |
        designer_mode: DesignerMode.toggle_button(
          designer_mode,
          button_name
          )
      }
      )
    }
  end

  def keypress(event, socket) do
    IO.puts("in keypress")
    IO.inspect(event)
    IO.inspect(socket)
    IO.inspect(socket.assigns.state)
    %{"key" => key_pressed} = event
    {:noreply,
    Socket.assign(
      socket,
      state: Action.update_state(key_pressed, socket.assigns.state)
    )
    }
  end

end
