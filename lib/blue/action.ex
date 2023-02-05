defmodule Blue.Action do

  alias Blue.DesignerModeButtons
  alias Blue.{Canvas, Sprite, Svg}

  # @spec update_canvas_designer_mode(Svg.coordinate.t(), State.t()) :: Canvas.t()
  def update_canvas_designer_mode({x, y}, state) do

    true_button = DesignerModeButtons.get_true_button(state.designer_mode.buttons)

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

  # @spec add_protagonist_sprite(Sprite.grid_coordinate.t(), Color.t(), Canvas.t()) :: Canvas.t()
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

  # @spec add_sprite(Sprite.grid_coordinate.t(), Sprite.type.t(), Color.t(), Canvas.t()) :: Canvas.t()
  def add_sprite(grid_coordinate, type, color, canvas) do

    new_sprite = %Sprite{
      color: color,
      grid_coordinate: grid_coordinate,
      type: type,
    }

    Canvas.add_sprite(canvas,new_sprite)
  end

  # @spec delete_sprite(Sprite.grid_coordinate.t(), Canvas.t()) :: Canvas.t()
  def delete_sprite(grid_coordinate, canvas) do
    sprite = Canvas.get_sprite_by_grid_coordinate(canvas, grid_coordinate)
    Canvas.remove_sprite(canvas,sprite)
  end

  # @spec remove_protagonist(Canvas.t()) :: Canvas.t()
  def remove_protagonist(canvas) do
    [protagonist | _] = canvas
      |> Canvas.get_sprites_by_type(:protagonist)
    IO.inspect(protagonist)
    Canvas.remove_sprite(canvas, protagonist)
  end

  # @spec update_canvas(String.t(), Canvas.t()) :: Canvas.t()
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

  # @spec move_protagonist(Sprite.direction.t(), Canvas.t()) :: Canvas.t()
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

  # @spec handle_adjacent_sprite(Canvas.t(), Sprite.direction.t(), Sprite.t()) :: Canvas.t()
  def handle_adjacent_sprite(canvas, direction, protagonist_sprite) do
    adjacent_sprite = Canvas.get_adjacent_sprite(canvas, direction, protagonist_sprite.grid_coordinate)

    case adjacent_sprite.type do
      :item -> handle_item_sprite(canvas, direction, protagonist_sprite, adjacent_sprite)
      :wall -> handle_wall_sprite(canvas)
    end

  end

  # @spec handle_item_sprite(Canvas.t(), Sprite.direction.t(), Sprite.t(), Sprite.t()) :: Canvas.t()
  def handle_item_sprite(canvas, direction, protagonist_sprite, item_sprite) do
    canvas
      |> Canvas.remove_sprite(item_sprite)
      |> Canvas.move_sprite(protagonist_sprite, direction)
  end

  # @spec handle_item_sprite(Canvas.t()) :: Canvas.t()
  def handle_wall_sprite(canvas) do
    canvas
  end

  # @spec get_direction(String.t()) :: Sprite.direction.t()
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
