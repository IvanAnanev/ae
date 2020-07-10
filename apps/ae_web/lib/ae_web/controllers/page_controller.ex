defmodule AeWeb.PageController do
  use AeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
