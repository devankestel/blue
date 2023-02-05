defmodule Blue.Action do

  alias Blue.{Canvas, Sprite, State, Svg}

  def update_canvas_designer_mode({x, y}, state) do
    IO.inspect(state)
    IO.puts("In svg_click")
    IO.puts("x #{x} y #{y}")

    designer_mode_buttons = state.designer_mode.buttons

    [{true_button, _} | _] = designer_mode_buttons
      |> Map.from_struct()
      |> Enum.filter(
        fn {_k, v} ->
          v
        end
    )
    IO.inspect(true_button)

    grid_coordinate = Svg.get_grid_coordinate(
      {x, y},
      state.canvas
    )

    IO.inspect(grid_coordinate)

    case true_button do
      :add_protagonist_sprite -> add_protagonist_sprite(grid_coordinate, :black, state.canvas)
      :add_red_item_sprite -> add_sprite(grid_coordinate, :item, :red, state.canvas)
      :add_blue_item_sprite -> add_sprite(grid_coordinate, :item, :blue, state.canvas)
      :add_wall_sprite -> add_sprite(grid_coordinate, :wall, :gray, state.canvas)
      :delete_sprite -> delete_sprite(grid_coordinate, state.canvas)
      _ -> state.canvas
    end
  end

  def add_protagonist_sprite(grid_coordinate, color, canvas) do
    canvas_has_protagonist? = canvas.sprites
      |> Enum.any?(
        fn s ->
          s.type == :protagonist
        end
      )
    canvas = cond do
      canvas_has_protagonist? -> remove_protagonist(canvas)
      true -> canvas
    end

    add_sprite(grid_coordinate, :protagonist, color, canvas)
  end

  def add_sprite(grid_coordinate, type, color, canvas) do

    new_sprite = %Sprite{
      color: color,
      grid_coordinate: grid_coordinate,
      type: type,
    }

    Canvas.add_sprite(canvas,new_sprite)
  end

  def delete_sprite(grid_coordinate, canvas) do
    sprite = Canvas.get_sprite_by_grid_coordinate(canvas, grid_coordinate)
    Canvas.remove_sprite(canvas,sprite)
  end

  def remove_protagonist(canvas) do
    [protagonist | _] = canvas
      |> Canvas.get_sprites_by_type(:protagonist)
    IO.inspect(protagonist)
    Canvas.remove_sprite(canvas, protagonist)
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
end
