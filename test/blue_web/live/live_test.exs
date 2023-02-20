defmodule BlueWeb.BlueLiveTest do
  use ExUnit.Case
  alias BlueWeb.BlueLive
  alias Blue.{Canvas, Sprite}


  describe "mount/3" do

    test "assigns to socket" do
      socket = %Phoenix.LiveView.Socket{}
      params = %{}
      session = nil

      {:ok, updated_socket} = BlueLive.mount(params, session, socket)

      updated_canvas = updated_socket.assigns.state.canvas
      assert updated_canvas.width == 200
      assert updated_canvas.height == 400
      assert updated_canvas.grid_size == 20
      assert Enum.at(updated_canvas.sprites, 0).color == :black
      assert Enum.at(updated_canvas.sprites, 1).color == :red

    end
  end

  describe "handle_event/3" do
    test "it handles the desired event" do

    end
  end

end
