defmodule BlueWeb.BlueLiveTest do
  use BlueWeb.ConnCase

  import Phoenix.LiveViewTest

  alias BlueWeb.BlueLive
  alias Blue.{Canvas, Sprite}

  defp parse_wall_sprites(
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


        # @TODO:
        # Fix the git security stuff
        # find count of each sprite on svg
        # assert other props like location
        # and maybe assert size?
        # figure out how to do a click event
        # and move the protagonist to collect a thing
        # and assert it all over again
        # This will definitely break a lot of unit tests
        # throughout the app.


        # IO.inspect(items)

        wall_sprites_count =
          wall_sprites
            |> length()

        IO.inspect("Wall count:")
        IO.inspect(wall_sprites_count)
          # |> Enum.map(&Floki.text(&1, sep: " "))
    
        parsed_wall_sprites = 
            wall_sprites
            |> Enum.map(&parse_wall_sprites(&1))
        IO.inspect("parsed wall sprites")
        IO.inspect(parsed_wall_sprites)

        first_wall_sprite = Enum.at(parsed_wall_sprites, 0)

      assert wall_sprites_count == 3
      assert first_wall_sprite.id == "wall_sprite"
      assert first_wall_sprite.width == "50px"
      assert first_wall_sprite.height == "50px"
      assert first_wall_sprite.x == "100"
      assert first_wall_sprite.y == "150"
      assert first_wall_sprite.viewbox == "0 0 512 512"


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
