defmodule BlueWeb.BlueLive do
  use BlueWeb, :live_view

  alias Blue.{Canvas, State}

  def mount(_params, _session, socket) do
    canvas = create_starting_canvas()

    state = %State{
      canvas: canvas,
      filename: "live.json",
      designer_mode: false,
      add_protagonist_sprite: false,
      add_red_item_sprite: false,
      add_blue_item_sprite: false,
      add_wall_sprite: false,
      delete_sprite: false,
    }

    {:ok, assign(
      socket,
      val: 0,
      state: state
      )}
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
      state: toggle_designer_mode(socket.assigns.state)
      )
    }
  end

  def handle_event("add_protagonist_sprite", _params, socket) do
    IO.inspect(socket.assigns.state)
    {:noreply,
    assign(
      socket,
      state: %{
        socket.assigns.state | add_protagonist_sprite: toggle_designer_mode_button(socket.assigns.state, socket.assigns.state.add_protagonist_sprite)
      }
      )
    }
  end
  def handle_event("add_blue_item_sprite", _params, socket) do
    IO.inspect(socket.assigns.state)
    {:noreply,
    assign(
      socket,
      state: %{
        socket.assigns.state | add_blue_item_sprite: toggle_designer_mode_button(socket.assigns.state, socket.assigns.state.add_blue_item_sprite)
      }
      )
    }
  end
  def handle_event("add_red_item_sprite", _params, socket) do
    IO.inspect(socket.assigns.state)
    {:noreply,
    assign(
      socket,
      state: %{
        socket.assigns.state | add_red_item_sprite: toggle_designer_mode_button(socket.assigns.state, socket.assigns.state.add_red_item_sprite)
      }
      )
    }
  end
  def handle_event("add_wall_sprite", _params, socket) do
    IO.inspect(socket.assigns.state)
    {:noreply,
    assign(
      socket,
      state: %{
        socket.assigns.state | add_wall_sprite: toggle_designer_mode_button(socket.assigns.state, socket.assigns.state.add_wall_sprite)
      }
      )
    }
  end
  def handle_event("delete_sprite", _params, socket) do
    IO.inspect(socket.assigns.state)
    {:noreply,
    assign(
      socket,
      state: %{
        socket.assigns.state | delete_sprite: toggle_designer_mode_button(socket.assigns.state, socket.assigns.state.delete_sprite)
      }
      )
    }
  end
  def toggle_designer_mode(state) do
    case state.designer_mode do
      true -> toggle_designer_mode_off(state)
      false -> %{state | designer_mode: true}
    end
  end

  def toggle_designer_mode_off(state) do
    state = %{state | designer_mode: false }
    state = %{state | add_protagonist_sprite: false }
    state = %{state | add_blue_item_sprite: false }
    state = %{state | add_red_item_sprite: false }
    state = %{state | add_wall_sprite: false }
    %{state | delete_sprite: false }
  end
  def toggle_designer_mode_button(state, current_value) do
    case state.designer_mode do
      true -> toggle(current_value)
      false -> current_value
    end
  end

  def toggle(current_value) do
    case current_value do
      true -> false
      false -> true
    end
  end

  def handle_event("keypress", params, socket) do
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

  def render(assigns) do
    ~H"""
    <div>
    <h1 class="text-4xl font-bold text-center">The count is: <%= @val %></h1>
    <p class="text-center">
    <form>
    <input type="text" value={@state.filename} />
    </form>
    <button phx-click="export">Export to JSON</button>
    <button phx-click="designer_mode">Designer mode: <%= @state.designer_mode %></button>
    <button phx-click="add_protagonist_sprite">Add protagonist sprite <%= @state.add_protagonist_sprite %></button>
    <button phx-click="add_red_item_sprite">Add red item sprite <%= @state.add_red_item_sprite %></button>
    <button phx-click="add_blue_item_sprite">Add blue item sprite <%= @state.add_blue_item_sprite %></button>
    <button phx-click="add_wall_sprite">Add wall sprite <%= @state.add_wall_sprite %></button>
    <button phx-click="delete_sprite">Delete sprite <%= @state.delete_sprite %></button>
    </p>
    <div phx-window-keydown="keypress">
    <%= raw Canvas.render(@state.canvas) %>
    </div>
    </div>
    """
  end

end
