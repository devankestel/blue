defmodule BlueWeb.BlueLive do
  use BlueWeb, :live_view

  alias Blue.{Canvas, Sprite, Svg}

  @canvas_width 200
  @canvas_height 400
  @grid_size 20


  def grid_size, do: @grid_size

  def canvas_width, do: @canvas_width

  def canvas_height, do: @canvas_height

  def mount(_params, _session, socket) do
    canvas = Canvas.new()

    protagonist_sprite = %Sprite{
    grid_coordinate: {1, 1},
    type: :protagonist,
    color: :black
    }

    item_sprite1 = %Sprite{
      grid_coordinate: {5, 5},
      color: :red,
      type: :item
    }

    item_sprite2 = %Sprite{
      grid_coordinate: {8, 8},
      color: :red,
      type: :item
    }

    item_sprite3 = %Sprite{
      grid_coordinate: {4, 8},
      color: :blue,
      type: :item
    }

    wall_sprite1 = %Sprite{
      grid_coordinate: {3, 4},
      color: :gray,
      type: :wall
    }

    wall_sprite2 = %Sprite{
      grid_coordinate: {3, 5},
      color: :gray,
      type: :wall
    }

    wall_sprite3 = %Sprite{
      grid_coordinate: {3, 6},
      color: :gray,
      type: :wall
    }

    canvas = %{canvas | sprites: [
      protagonist_sprite,
      item_sprite1,
      item_sprite2,
      item_sprite3,
      wall_sprite1,
      wall_sprite2,
      wall_sprite3
      ]}
    {:ok, assign(
      socket,
      val: 0,
      canvas: canvas
      )}
  end

  def handle_event("inc", _unsigned_params, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  def handle_event("dec", _unsigned_params, socket) do
    {:noreply, update(socket, :val, &(&1 - 1))}
  end

  def handle_event("keypress", params, socket) do
    IO.inspect(params)
    IO.inspect(socket)
    IO.inspect(socket.assigns.canvas)
    %{"key" => key_pressed} = params
    {:noreply,
    assign(
      socket,
      canvas: update_canvas(key_pressed, socket.assigns.canvas)
      )
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

  def render(assigns) do
    ~H"""
    <div>
    <h1 class="text-4xl font-bold text-center">The count is: <%= @val %></h1>
    <p class="text-center">
    <button phx-click="dec">-</button>
    <button phx-click="inc">+</button>
    </p>
    <div phx-window-keydown="keypress">
    <%= raw Canvas.render(@canvas) %>
    </div>
    </div>
    """
  end

end
