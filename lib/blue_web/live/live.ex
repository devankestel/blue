defmodule BlueWeb.BlueLive do
  use BlueWeb, :live_view

  alias Blue.Sprite

  @canvas_width 200
  @canvas_height 400
  @grid_size 20


  def grid_size, do: @grid_size

  def canvas_width, do: @canvas_width

  def canvas_height, do: @canvas_height

  def mount(_params, _session, socket) do
    {:ok, assign(
      socket,
      val: 0,
      location: {100, 0},
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
    {:noreply, assign(
      socket,
      location: update_location(key_pressed, socket.assigns.location))}
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
    <%= raw svg_head %>
    <%= raw square(@location) %>
    <%= raw svg_foot %>
    </div>
    </div>
    """
  end

  def svg_head() do
    """
    <svg
    version="1.0"
    style="background-color: #F8F8F8"
    id="Layer_1"
    xmlns="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    width="200" height="400"
    viewBox="0 0 200 400"
    xml:space="preserve">
    """
  end

  def svg_foot(), do: "</svg>"

  def square(location) do
    {x, y} = location
    """
    <rect
      x="#{x}" y="#{y}"
      style="fill:#000;"
      width="#{@grid_size}" height="#{@grid_size}"/>
    """
  end

end
