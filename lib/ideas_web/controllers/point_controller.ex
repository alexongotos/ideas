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
    session = conn.assigns[:session]
    changeset = Meetup.change_point(%Point{})

    render(conn, "new.html", changeset: changeset, ideas: ideas, session_id: session.id)
  end

  def create(conn, %{"point" => point_params}) do
    case Meetup.create_point(point_params) do
      {:ok, point} ->
        conn
        |> put_flash(:info, "Point created successfully.")
        |> redirect(to: point_path(conn, :show, point))

      {:error, %Ecto.Changeset{} = changeset} ->
        ideas = Meetup.list_ideas() |> Enum.map(fn i -> {i.title, i.id} end)
        session = conn.assigns[:session]

        render(conn, "new.html", changeset: changeset, ideas: ideas, session_id: session.id)
    end
  end

  def show(conn, %{"id" => id}) do
    point = Meetup.get_point!(id)

    render(conn, "show.html", point: point)
  end

  def edit(conn, %{"id" => id}) do
    ideas = Meetup.list_ideas() |> Enum.map(fn i -> {i.title, i.id} end)
    session = conn.assigns[:session]
    point = Meetup.get_point!(id)
    changeset = Meetup.change_point(point)

    render(
      conn,
      "edit.html",
      point: point,
      changeset: changeset,
      ideas: ideas,
      session_id: session.id
    )
  end

  def update(conn, %{"id" => id, "point" => point_params}) do
    point = Meetup.get_point!(id)

    case Meetup.update_point(point, point_params) do
      {:ok, point} ->
        conn
        |> put_flash(:info, "Point updated successfully.")
        |> redirect(to: point_path(conn, :show, point))

      {:error, %Ecto.Changeset{} = changeset} ->
        ideas = Meetup.list_ideas() |> Enum.map(fn i -> {i.title, i.id} end)
        session = conn.assigns[:session]

        render(
          conn,
          "edit.html",
          point: point,
          changeset: changeset,
          ideas: ideas,
          session_id: session.id
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
