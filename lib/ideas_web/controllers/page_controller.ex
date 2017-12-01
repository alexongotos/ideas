defmodule IdeasWeb.PageController do
  use IdeasWeb, :controller
  alias Ideas.Meetup
  def index(conn, _params) do
    ideas = Meetup.list_ideas()
    render(conn, "index.html", ideas: ideas)
  end
end
