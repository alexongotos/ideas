defmodule Ideas.Meetup do
  @moduledoc """
  The Meetup context.
  """

  import Ecto.Query, warn: false
  alias Ideas.Repo

  alias Ideas.Meetup.Idea
  alias Ideas.Meetup.Session
  alias Ideas.Meetup.Point

  @doc """
  Returns the list of ideas.

  ## Examples

      iex> list_ideas()
      [%Idea{}, ...]

  """
  def list_ideas do
    # q1 = from votes in Vote,
    #      group_by: votes.request_id,
    #      select: %{request_id: votes.request_id, total_rating: sum(votes.rating)}
    #
    # q2 = from request in Request,
    #      left_join: song in assoc(request, :song),
    #      left_join: rating in subquery(q2), on: request.id == rating.request_id,
    #      where: request.zone_id == ^zone_id and request.times_played <= ^max_played,
    #      select: %{title: song.title, url: song.url, thumbnail: song.thumbnail, rating: rating.total_rating},
    #      order_by:  [asc: request.times_played, desc: request.inserted_at]

    q1 =
      from(
        points in Point,
        group_by: points.idea_id,
        select: %{idea_id: points.idea_id, total_score: sum(points.score)}
      )

    q2 =
      from(
        idea in Idea,
        left_join: point in subquery(q1),
        on: idea.id == point.idea_id,
        select: %Idea{
          id: idea.id,
          title: idea.title,
          description: idea.description,
          score: point.total_score,
          inserted_at: idea.inserted_at,
          updated_at: idea.updated_at
        },
        order_by: [asc: point.total_score]
      )

    Repo.all(q2) |> Repo.preload(:points)
  end

  @doc """
  Gets a single idea.

  Raises `Ecto.NoResultsError` if the Idea does not exist.

  ## Examples

      iex> get_idea!(123)
      %Idea{}

      iex> get_idea!(456)
      ** (Ecto.NoResultsError)

  """
  def get_idea!(id), do: Repo.get!(Idea, id)

  @doc """
  Creates a idea.

  ## Examples

      iex> create_idea(%{field: value})
      {:ok, %Idea{}}

      iex> create_idea(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_idea(attrs \\ %{}) do
    %Idea{}
    |> Idea.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a idea.

  ## Examples

      iex> update_idea(idea, %{field: new_value})
      {:ok, %Idea{}}

      iex> update_idea(idea, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_idea(%Idea{} = idea, attrs) do
    idea
    |> Idea.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Idea.

  ## Examples

      iex> delete_idea(idea)
      {:ok, %Idea{}}

      iex> delete_idea(idea)
      {:error, %Ecto.Changeset{}}

  """
  def delete_idea(%Idea{} = idea) do
    Repo.delete(idea)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking idea changes.

  ## Examples

      iex> change_idea(idea)
      %Ecto.Changeset{source: %Idea{}}

  """
  def change_idea(%Idea{} = idea) do
    Idea.changeset(idea, %{})
  end

  @doc """
  Returns the list of sessions.

  ## Examples

      iex> list_sessions()
      [%Session{}, ...]

  """
  def list_sessions do
    Repo.all(Session)
  end

  @doc """
  Gets a single session.

  Raises `Ecto.NoResultsError` if the Session does not exist.

  ## Examples

      iex> get_session!(123)
      %Session{}

      iex> get_session!(456)
      ** (Ecto.NoResultsError)

  """
  def get_session!(id), do: Repo.get!(Session, id)

  @doc """
  Creates a session.

  ## Examples

      iex> create_session(%{field: value})
      {:ok, %Session{}}

      iex> create_session(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_session(attrs \\ %{}) do
    %Session{}
    |> Session.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a session.

  ## Examples

      iex> update_session(session, %{field: new_value})
      {:ok, %Session{}}

      iex> update_session(session, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_session(%Session{} = session, attrs) do
    session
    |> Session.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Session.

  ## Examples

      iex> delete_session(session)
      {:ok, %Session{}}

      iex> delete_session(session)
      {:error, %Ecto.Changeset{}}

  """
  def delete_session(%Session{} = session) do
    Repo.delete(session)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking session changes.

  ## Examples

      iex> change_session(session)
      %Ecto.Changeset{source: %Session{}}

  """
  def change_session(%Session{} = session) do
    Session.changeset(session, %{})
  end

  @doc """
  Creates a point.

  ## Examples

      iex> create_point(%{field: value})
      {:ok, %Point{}}

      iex> create_point(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_point(attrs \\ %{}) do
    %Point{}
    |> Point.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns the list of points.

  ## Examples

      iex> list_points()
      [%Point{}, ...]

  """
  def list_points do
    Repo.all(Point) |> Repo.preload([:idea, :session])
  end

  @doc """
  Gets a single point.

  Raises `Ecto.NoResultsError` if the Point does not exist.

  ## Examples

      iex> get_point!(123)
      %Point{}

      iex> get_point!(456)
      ** (Ecto.NoResultsError)

  """
  def get_point!(id), do: Repo.get!(Point, id) |> Repo.preload([:idea, :session])

  @doc """
  Deletes a Point.

  ## Examples

      iex> delete_point(point)
      {:ok, %Point{}}

      iex> delete_point(point)
      {:error, %Ecto.Changeset{}}

  """
  def delete_point(%Point{} = point) do
    Repo.delete(point)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking point changes.

  ## Examples

      iex> change_point(point)
      %Ecto.Changeset{source: %Point{}}

  """
  def change_point(%Point{} = point) do
    Point.changeset(point, %{})
  end

  @doc """
  Updates a point.

  ## Examples

      iex> update_point(point, %{field: new_value})
      {:ok, %Point{}}

      iex> update_point(point, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_point(%Point{} = point, attrs) do
    point
    |> Point.changeset(attrs)
    |> IO.inspect(label: "Update Point: ")
    |> Repo.update()
  end
end
