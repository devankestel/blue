defmodule BlueWeb.BlueLive do
  use BlueWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(
      socket,
      val: 0,
      location: {50, 50},
      )}
  end

  def handle_event("inc", _unsigned_params, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  def handle_event("dec", _unsigned_params, socket) do
    {:noreply, update(socket, :val, &(&1 - 1))}
  end

  def handle_event("keypress", %{"key" => key_pressed}, socket) do
    {:noreply, assign(
      socket,
      location: update_location(key_pressed))}
  end

  def update_location(key_pressed) do
    direction = get_direction(key_pressed)
    case direction do
      :up -> {5,5}
      :down -> {10,10}
      :left ->  {15,15}
      :right ->  {20,20}
      _ -> {50, 50}
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
      width="#{20}" height="#{20}"/>
    """
  end

end