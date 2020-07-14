defmodule AeWeb.PageLiveTest do
  use AeWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Categories"
    assert render(page_live) =~ "Categories"
  end
end
