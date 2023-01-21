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
    protagonist_sprite = Sprite.new()
    protagonist_sprite = %{protagonist_sprite | type: :protagonist}
    item_sprite = Sprite.new()
    item_sprite = %{item_sprite | grid_coordinate: {5, 5}}
    item_sprite = %{item_sprite | color: :red}
    canvas = %{canvas | sprites: [protagonist_sprite, item_sprite]}
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
    cond do
      Canvas.has_item?(canvas) ->
        move_protagonist_with_item(direction, canvas)
      true ->
       move_protagonist_without_item(direction, canvas)
    end
  end

  def move_protagonist_with_item(direction, canvas) do
    protagonist_sprite = Canvas.get_sprites_by_type(canvas, :protagonist) |> Enum.at(0)
    item_sprite = Enum.at(canvas.sprites, 1)
    cond do
      Canvas.is_at_grid_edge?(canvas, direction, protagonist_sprite.grid_coordinate) ->
        canvas
      Canvas.can_collect_item?(direction, protagonist_sprite.grid_coordinate, item_sprite.grid_coordinate) ->
        canvas
         |> Canvas.remove_sprite(item_sprite)
         |> Canvas.move_sprite(protagonist_sprite, direction)
      true ->
        canvas
          |> Canvas.move_sprite(protagonist_sprite, direction)
    end
  end

  def move_protagonist_without_item(direction, canvas) do
    protagonist_sprite = Canvas.get_sprites_by_type(canvas, :protagonist) |> Enum.at(0)
    cond do
      Canvas.is_at_grid_edge?(canvas, direction, protagonist_sprite.grid_coordinate) ->
        canvas
      true ->
        canvas
          |> Canvas.move_sprite(protagonist_sprite, direction)
    end
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
