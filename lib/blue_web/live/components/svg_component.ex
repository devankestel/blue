defmodule BlueWeb.SvgComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  use BlueWeb, :live_component
  alias Blue.{Canvas, Sprite}

  def handle_event("edit_canvas", params, socket) do

    IO.inspect(params)
    IO.inspect(socket.assigns.state)
    IO.puts("In edit_canvas ")

    new_sprite = %Sprite{
      color: :green,
      grid_coordinate: {2, 2},
      type: :none
    }
    sprites = socket.assigns.state.canvas.sprites
    sprites = [new_sprite | sprites]
    IO.inspect(sprites)
    {:noreply,
    assign(
      socket,
      state: %{
        socket.assigns.state |
        canvas: %{socket.assigns.state.canvas | sprites: sprites}
      }
    )
    }
  end

  def handle_event("svg_click", params, socket) do

    IO.inspect(socket.assigns.state)
    IO.puts("In svg_click")
    IO.inspect(params)

    {:noreply, socket}
  end
end
