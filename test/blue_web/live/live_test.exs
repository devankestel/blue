defmodule BlueWeb.BlueLiveTest do
  use BlueWeb.ConnCase

  import Phoenix.LiveViewTest

  alias BlueWeb.BlueLive
  alias Blue.{Canvas, Sprite}

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
      #       In testing, the view is stateful/mutable, so you can do something like this:

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
        items =
          parsed_fragment
          |> Floki.find("#wall_sprite")

        # @TODO: find count of each sprite on svg
        # assert other props like location
        # and maybe assert size?
        # figure out how to do a click event
        # and move the protagonist to collect a thing
        # and assert it all over again
        # This will definitely break a lot of unit tests
        # throughout the app.


        # IO.inspect(items)

        items_count =
          items
            |> length()

        IO.inspect("Wall count:")
        IO.inspect(items_count)
          # |> Enum.map(&Floki.text(&1, sep: " "))

      assert items_count == 80
      assert items == ["item 1", "item 2"]


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
