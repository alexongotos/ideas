defmodule IdeasWeb.IdeaController do
  use IdeasWeb, :controller

  alias Ideas.Repo
  alias Ideas.Meetup
  alias Ideas.Meetup.Idea
  # alias Ideas.Meetup.Session
  alias Ideas.Meetup.Point

  def index(conn, _params) do
    new_idea = Meetup.change_idea(%Idea{})
    session = conn.assigns[:session]

    ideas =
      Meetup.list_ideas_by_score()
      |> Enum.map(fn idea ->
           point = Repo.get_by(Meetup.Point, session_id: session.id, idea_id: idea.id)

           case point do
             nil -> changeset = Meetup.change_point(%Point{})
             point -> changeset = Meetup.change_point(point)
           end

           action =
             if point do
               idea_path(conn, :update, point)
             else
               idea_path(conn, :create)
             end

           IO.inspect(action, label: "Index:: ")

           {idea, changeset, action}
         end)

    render(
      conn,
      "index.html",
      ideas: ideas,
      changeset: new_idea,
      session_id: session.id
    )
  end

  def new(conn, _params) do
    changeset = Meetup.change_idea(%Idea{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"idea" => idea_params}) do
    case Meetup.create_idea(idea_params) do
      {:ok, idea} ->
        conn
        |> put_flash(:info, "Idea created successfully.")
        |> redirect(to: idea_path(conn, :show, idea))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"point" => point_params}) do
    case Meetup.create_point(point_params) do
      {:ok, point} ->
        conn
        |> put_flash(:info, "Point created successfully.")
        |> redirect(to: idea_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        ideas = Meetup.list_ideas() |> Enum.map(fn i -> {i.title, i.id} end)
        session = conn.assigns[:session]

        render(conn, "new.html", changeset: changeset, ideas: ideas, session_id: session.id)
    end
  end

  def show(conn, %{"id" => id}) do
    idea = Meetup.get_idea!(id)
    render(conn, "show.html", idea: idea)
  end

  def edit(conn, %{"id" => id}) do
    idea = Meetup.get_idea!(id)
    changeset = Meetup.change_idea(idea)
    render(conn, "edit.html", idea: idea, changeset: changeset)
  end

  def update(conn, %{"id" => id, "idea" => idea_params}) do
    idea = Meetup.get_idea!(id)

    case Meetup.update_idea(idea, idea_params) do
      {:ok, idea} ->
        conn
        |> put_flash(:info, "Idea updated successfully.")
        |> redirect(to: idea_path(conn, :show, idea))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", idea: idea, changeset: changeset)
    end
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
    idea = Meetup.get_idea!(id)
    {:ok, _idea} = Meetup.delete_idea(idea)

    conn
    |> put_flash(:info, "Idea deleted successfully.")
    |> redirect(to: idea_path(conn, :index))
  end
end
