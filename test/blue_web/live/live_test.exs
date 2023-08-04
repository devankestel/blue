defmodule BlueWeb.BlueLiveTest do
  use BlueWeb.ConnCase

  import Phoenix.LiveViewTest

  alias BlueWeb.BlueLive
  alias Blue.{Canvas, Sprite}

  defp parse_sprites(
    {
        "svg",
        [
            {"id", id},
            {"width", width},
            {"height", height},
            {"x", x},
            {"y", y},
            {"viewbox", viewbox}
        ],
        _,
    }
    ) do
    
    %{
        id: id,
        width: width, 
        height: height, 
        x: x,
        y: y,
        viewbox: viewbox 
    }
  end

  defp get_sprite_props_and_count(parsed_fragment, sprite_id) do
    sprite_props =
            parsed_fragment
            |> Floki.find(sprite_id)
            |> Enum.map(&parse_sprites(&1))

    IO.inspect("#{sprite_id} Found:")
    IO.inspect(sprite_props)

    sprites_count =
        sprite_props
        |> length()

    IO.inspect("#{sprite_id} count:")
    IO.inspect(sprites_count)
    {sprite_props, sprites_count}
  end


  defp wall_sprite_assertions(wall_sprite) do
    assert wall_sprite.id == "wall_sprite"
    assert wall_sprite.width == "50px"
    assert wall_sprite.height == "50px"
    assert wall_sprite.viewbox == "0 0 512 512" 
  end

  describe "basic rendering" do
    test "renders our game page", %{conn: conn} do
      {:ok, view, html} = live(conn, "/blue")

      assert html =~ "Blue"
      assert render(view) =~ "Blue"
    end
  end

  describe "designer mode" do
    test "click on designer mode?", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/blue")


      element_result = view
      |> element("#designer-mode-button", "Designer mode")
      IO.inspect("element result")
      IO.inspect(element_result)
      html = element_result
      |> render_click()

      assert html =~ "Designer mode: true"
      assert html =~ "Add protagonist sprite"
      assert html =~ "Add red item sprite"
      assert html =~ "Add blue item sprite"
      assert html =~ "Add wall sprite"
      assert html =~ "Delete sprite"

    end

    test "add a protagonist", %{conn: conn} do
        # In testing, the view is stateful/mutable, so you can do something like this:

        # {:ok, view, _html} = live(conn, "/path")

        # view |> element("#open-form-button") |> render_click

        # view |> form("#my-form", %{foo: %{bar: "baz"}}) |> render_submit

        # assert render(view) =~ "form was submitted!"


        {:ok, view, _html} = live(conn, "/blue")


        element_result = view
            |> element("#designer-mode-button", "Designer mode")

        html = element_result
            |> render_click()

        view
            |> element("button", "protagonist")
            |> render_click()

        parsed_fragment =
            view
            |> render()
            |> Floki.parse_fragment!()

        # IO.inspect(parsed_fragment)
        wall_sprites =
            parsed_fragment
            |> Floki.find("#wall_sprite")

        # IO.inspect(items)

        wall_sprites_count =
          wall_sprites
            |> length()

        IO.inspect("Wall count:")
        IO.inspect(wall_sprites_count)
          # |> Enum.map(&Floki.text(&1, sep: " "))
    
        parsed_wall_sprites = 
            wall_sprites
            |> Enum.map(&parse_sprites(&1))
        IO.inspect("parsed wall sprites")
        IO.inspect(parsed_wall_sprites)

        first_wall_sprite = Enum.at(parsed_wall_sprites, 0)
        second_wall_sprite = Enum.at(parsed_wall_sprites, 1)
        third_wall_sprite = Enum.at(parsed_wall_sprites, 2)

        assert wall_sprites_count == 3
        assert first_wall_sprite.x == "100"
        assert first_wall_sprite.y == "150"
        assert second_wall_sprite.x == "100"
        assert second_wall_sprite.y == "200"
        assert third_wall_sprite.x == "100"
        assert third_wall_sprite.y == "250"
      

        parsed_wall_sprites
            |> Enum.each(& wall_sprite_assertions(&1))

        {lemon_sprites_props, lemon_sprites_count} = get_sprite_props_and_count(parsed_fragment, "#lemon_sprite")

        assert lemon_sprites_count == 2

        # # export html to doc
        # File.write("lib/blue/rendered_html_test.html", html)
        # # export result to doc
        # File.write("lib/blue/rendered_element_result_test.html", IO.inspect(result))

        # assert html =~ "Designer mode: true"
        # assert html =~ "Add protagonist sprite"
        # assert html =~ "Add red item sprite"
        # assert html =~ "Add blue item sprite"
        # assert html =~ "Add wall sprite"
        # assert html =~ "Delete sprite"

    end
  end


  describe "mount/3" do

    test "assigns to socket" do
      socket = %Phoenix.LiveView.Socket{}
      params = %{}
      session = nil

      {:ok, updated_socket} = BlueLive.mount(params, session, socket)

      updated_canvas = updated_socket.assigns.state.canvas
      assert updated_canvas.width == 500
      assert updated_canvas.height == 500
      assert updated_canvas.grid_size == 50
      assert Enum.at(updated_canvas.sprites, 0).color == :black
      assert Enum.at(updated_canvas.sprites, 1).color == :red

    end
  end

end
