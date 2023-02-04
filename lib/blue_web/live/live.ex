defmodule BlueWeb.BlueLive do
  use BlueWeb, :live_view

  alias Blue.{Canvas, Sprite, State, DesignerMode}
  alias BlueWeb.{HeroComponent, DesignerModeComponent, SvgComponent}

  def mount(params, session, socket) do

    state = State.new()
    state = %{ state | canvas: create_starting_canvas()}
    IO.inspect(params)
    IO.inspect(session)

    {:ok, assign(
      socket,
      val: 0,
      state: state
      )}
  end

  def handle_event("svg_click", event, socket) do

    IO.inspect(socket.assigns.state)
    IO.puts("In svg_click")
    IO.inspect(event)

    {:noreply, socket}
  end

  def handle_event("inc", _unsigned_params, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  def handle_event("export", _unsigned_params, socket) do
    IO.inspect(socket.assigns.state.filename)
    Canvas.to_json(socket.assigns.state.canvas, "lib/blue_web/live/json_exports/export_canvas.json")
    {:noreply, socket}
  end

  def handle_event("designer_mode", _params, socket) do
    IO.inspect(socket.assigns.state)
    {:noreply,
    assign(
      socket,
      state: %{
        socket.assigns.state |
        designer_mode: DesignerMode.toggle(socket.assigns.state.designer_mode)
      }
    )
    }
  end



  def handle_event("add_protagonist_sprite", _params, socket) do
    IO.inspect(socket.assigns.state)
    designer_mode = socket.assigns.state.designer_mode
    {:noreply,
    assign(
      socket,
      state: %{
        socket.assigns.state |
        designer_mode: DesignerMode.toggle_button(
          designer_mode,
          :add_protagonist_sprite
          )
      }
      )
    }
  end

  def handle_event("add_blue_item_sprite", _params, socket) do
    IO.inspect(socket.assigns.state)
    designer_mode = socket.assigns.state.designer_mode
    {:noreply,
    assign(
      socket,
      state: %{
        socket.assigns.state |
        designer_mode: DesignerMode.toggle_button(
          designer_mode,
          :add_blue_item_sprite
          )
      }
      )
    }
  end

  def handle_event("add_red_item_sprite", _params, socket) do
    IO.inspect(socket.assigns.state)
    designer_mode = socket.assigns.state.designer_mode
    {:noreply,
    assign(
      socket,
      state: %{
        socket.assigns.state |
        designer_mode: DesignerMode.toggle_button(
          designer_mode,
          :add_red_item_sprite
          )
      }
      )
    }
  end

  def handle_event("add_wall_sprite", _params, socket) do
    IO.inspect(socket.assigns.state)
    designer_mode = socket.assigns.state.designer_mode
    {:noreply,
    assign(
      socket,
      state: %{
        socket.assigns.state |
        designer_mode: DesignerMode.toggle_button(
          designer_mode,
          :add_wall_sprite
          )
      }
      )
    }
  end

  def handle_event("delete_sprite", _params, socket) do
    IO.inspect(socket.assigns.state)
    designer_mode = socket.assigns.state.designer_mode
    {:noreply,
    assign(
      socket,
      state: %{
        socket.assigns.state |
        designer_mode: DesignerMode.toggle_button(
          designer_mode,
          :delete_sprite
          )
      }
      )
    }
  end

  def handle_event("keypress", params, socket) do
    IO.puts("in keypress")
    IO.inspect(params)
    IO.inspect(socket)
    IO.inspect(socket.assigns.state)
    %{"key" => key_pressed} = params
    {:noreply,
    assign(
      socket,
      state: update_state(key_pressed, socket.assigns.state)
      )
    }
  end

  def update_state(key_pressed, state) do
    updated_canvas = update_canvas(key_pressed, state.canvas)
    %State{
      canvas: updated_canvas,
      filename: state.filename,
    }
  end

  def update_canvas(key_pressed, canvas) do
    direction = get_direction(key_pressed)
    case direction do
      :up -> move_protagonist(:up, canvas)
      :down -> move_protagonist(:down, canvas)
      :left -> move_protagonist(:left, canvas)
      :right -> move_protagonist(:right, canvas)
      _ -> canvas
    end
  end

  def move_protagonist(direction, canvas) do
    protagonist_sprite = Canvas.get_sprites_by_type(canvas, :protagonist) |> Enum.at(0)

    cond do
      Canvas.is_at_grid_edge?(canvas, direction, protagonist_sprite.grid_coordinate) ->
        canvas
      Canvas.has_adjacent_sprite?(canvas, direction, protagonist_sprite.grid_coordinate) ->
        handle_adjacent_sprite(canvas, direction, protagonist_sprite)
      true ->
        canvas
          |> Canvas.move_sprite(protagonist_sprite, direction)
    end
  end

  def handle_adjacent_sprite(canvas, direction, protagonist_sprite) do
    adjacent_sprite = Canvas.get_adjacent_sprite(canvas, direction, protagonist_sprite.grid_coordinate)

    case adjacent_sprite.type do
      :item -> handle_item_sprite(canvas, direction, protagonist_sprite, adjacent_sprite)
      :wall -> handle_wall_sprite(canvas)
    end

  end

  def handle_item_sprite(canvas, direction, protagonist_sprite, item_sprite) do
    canvas
      |> Canvas.remove_sprite(item_sprite)
      |> Canvas.move_sprite(protagonist_sprite, direction)
  end

  def handle_wall_sprite(canvas) do
    canvas
  end

  def get_direction(key_pressed) do
    case key_pressed do
      "ArrowLeft" -> :left
      "ArrowRight" -> :right
      "ArrowUp" -> :up
      "ArrowDown" -> :down
      _ -> :nomatch
    end
  end

  def create_starting_canvas() do
    Canvas.from_json("test/blue/fixtures/example_canvas.json")
  end

end
