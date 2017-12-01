defmodule IdeasWeb.PointController do
  use IdeasWeb, :controller

  alias Ideas.Meetup
  alias Ideas.Meetup.Point

  def index(conn, _params) do
    points = Meetup.list_points()
    render(conn, "index.html", points: points)
  end

  def new(conn, _params) do
    ideas = Meetup.list_ideas() |> Enum.map(fn i -> {i.title, i.id} end)
    sessions = Meetup.list_sessions() |> Enum.map(fn s -> {s.name, s.id} end)
    changeset = Meetup.change_point(%Point{})
    render(conn, "new.html", changeset: changeset, ideas: ideas, sessions: sessions)
  end

  def create(conn, %{"point" => point_params}) do
    case Meetup.create_point(point_params) do
      {:ok, point} ->
        conn
        |> put_flash(:info, "Point created successfully.")
        |> redirect(to: point_path(conn, :show, point))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    point = Meetup.get_point!(id)
    render(conn, "show.html", point: point)
  end

  def edit(conn, %{"id" => id}) do
    ideas = Meetup.list_ideas() |> Enum.map(fn i -> {i.title, i.id} end)
    sessions = Meetup.list_sessions() |> Enum.map(fn s -> {s.name, s.id} end)
    point = Meetup.get_point!(id)
    changeset = Meetup.change_point(point)

    render(
      conn,
      "edit.html",
      point: point,
      changeset: changeset,
      ideas: ideas,
      sessions: sessions
    )
  end

  def update(conn, %{"id" => id, "point" => point_params}) do
    IO.puts("HERE ARE POINT PARAMS #{inspect(point_params)}")
    point = Meetup.get_point!(id)

    case Meetup.update_point(point, point_params) do
      {:ok, point} ->
        conn
        |> put_flash(:info, "Point updated successfully.")
        |> redirect(to: point_path(conn, :show, point))

      {:error, %Ecto.Changeset{} = changeset} ->
        ideas = Meetup.list_ideas() |> Enum.map(fn i -> {i.title, i.id} end)
        sessions = Meetup.list_sessions() |> Enum.map(fn s -> {s.name, s.id} end)

        render(
          conn,
          "edit.html",
          point: point,
          changeset: changeset,
          ideas: ideas,
          sessions: sessions
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    point = Meetup.get_point!(id)
    {:ok, _point} = Meetup.delete_point(point)

    conn
    |> put_flash(:info, "Point deleted successfully.")
    |> redirect(to: point_path(conn, :index))
  end
end
