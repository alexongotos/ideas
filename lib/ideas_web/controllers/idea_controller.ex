defmodule IdeasWeb.IdeaController do
  use IdeasWeb, :controller

  alias Ideas.Meetup
  alias Ideas.Meetup.Idea

  def index(conn, _params) do
    new_idea = Meetup.change_idea(%Idea{})
    ideas = Meetup.list_ideas()
    render(conn, "index.html", [ideas: ideas, changeset: new_idea])
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

  def delete(conn, %{"id" => id}) do
    idea = Meetup.get_idea!(id)
    {:ok, _idea} = Meetup.delete_idea(idea)

    conn
    |> put_flash(:info, "Idea deleted successfully.")
    |> redirect(to: idea_path(conn, :index))
  end
end
