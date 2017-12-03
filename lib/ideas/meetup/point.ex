defmodule Ideas.Meetup.Point do
  @moduledoc """
  The Point schema.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Ideas.Meetup.Point
  alias Ideas.Meetup.Session
  alias Ideas.Meetup.Idea

  schema "points" do
    field(:score, :integer)
    # field :session_id, :id
    # field :idea_id, :id

    belongs_to(:session, Session)
    belongs_to(:idea, Idea)

    timestamps()
  end

  @doc false
  def changeset(%Point{} = point, attrs) do
    point
    |> cast(attrs, [:score, :session_id, :idea_id])
    |> unique_constraint(:one_vote_per_idea, name: :points_session_id_idea_id_index)
    |> validate_required([:score, :session_id, :idea_id])
  end
end
