defmodule CircularWeb.PageLiveTest do
  use CircularWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Welcome to Circular App"
    assert render(page_live) =~ "Welcome to Circular App"
  end
end
