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
    {:ok, assign(
      socket,
      val: 0,
      location: {100, 0},
      sprite: Sprite.new(),
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
    IO.inspect(socket.assigns.location)
    %{"key" => key_pressed} = params
    {:noreply,
    assign(
      socket,
      location: update_location(key_pressed, socket.assigns.location),
      canvas: update_canvas(key_pressed, socket.assigns.canvas)
      )
    }
  end

  def update_location(key_pressed, location) do
    direction = get_direction(key_pressed)
    case direction do
      :up -> move(:up, location)
      :down -> move(:down, location)
      :left -> move(:left, location)
      :right ->  move(:right, location)
      _ -> location
    end
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
    sprite = Enum.at(canvas.sprites, 0)

    cond do
      Canvas.is_at_grid_edge?(canvas, direction, sprite.grid_coordinate) ->
        canvas
      true ->
        sprite = sprite |> Sprite.move(direction)
        %{canvas | sprites: [sprite]}
    end
  end




  @spec move(Sprite.direction(), Sprite.position()) :: Sprite.position()
  def move(:down, location) do
    {x, y} = location
    cond do
      y <= (@canvas_height - 2*@grid_size) -> {x, y + @grid_size}
      true -> {x, y}
    end
  end

  def move(:up, location) do
    {x, y} = location
    cond do
      y >= @grid_size -> {x, y - @grid_size}
      true -> {x, y}
    end
  end

  def move(:right, location) do
    {x, y} = location
    cond do
      x <= (@canvas_width - 2*@grid_size) -> {x + @grid_size, y}
      true -> {x, y}
    end
  end

  def move(:left, location) do
    {x, y} = location
    cond do
      x >= @grid_size -> {x - @grid_size, y}
      true -> {x, y}
    end
  end

  @spec is_at_edge?(Sprite.direction(), Sprite.position()) :: boolean()
  def is_at_edge?(direction, location) do
    {x, y} = location

    case direction do
      :right -> (x >= (@canvas_width - 2*@grid_size))
      :left -> x <= @grid_size
      _ -> false
    end
  end

  def is_at_grid_edge?(direction, grid_coordinate) do
    {col, row} = grid_coordinate

    case direction do
      :left -> col <= 1
      :right -> col >= get_num_cols()
      :up -> row <= 1
      :down -> row >= get_num_rows()
      _ -> false
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
    <%= raw Svg.header(Canvas.new()) %>
    <%= raw square(@location, "#000") %>
    <%= raw Canvas.render(@canvas) %>
    <%= raw Svg.footer %>
    </div>
    </div>
    """
  end

  def square(location, color) do
    {x, y} = location
    """
    <rect
      x="#{x}" y="#{y}"
      style="fill:#{color};"
      width="#{@grid_size}" height="#{@grid_size}"/>
    """
  end

  @spec get_svg_coordinate(Sprite.grid_coordinate()) :: {number, number}
  def get_svg_coordinate(grid_coordinate) do
    {x, y} = grid_coordinate
    {(x-1)*@grid_size, (y-1)*@grid_size}
  end

  @spec get_num_cols :: float
  def get_num_cols() do
    @canvas_width/@grid_size
  end

  @spec get_num_rows :: float
  def get_num_rows() do
    @canvas_height/@grid_size
  end

end
