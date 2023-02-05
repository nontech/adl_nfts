defmodule AngryWeb.PageController do
  use AngryWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
