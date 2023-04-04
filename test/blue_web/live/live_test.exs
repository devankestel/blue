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

  describe "click events?" do
    test "click on designer mode?", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/blue")


      html = view
      |> element("button", "Designer mode")
      |> render_click()

      assert html =~ "Designer mode: true"
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
