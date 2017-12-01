defmodule IdeasWeb.PageController do
  use IdeasWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
