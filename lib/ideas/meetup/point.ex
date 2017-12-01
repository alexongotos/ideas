defmodule Ideas.Meetup.Point do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ideas.Meetup.Point
  alias Ideas.Meetup.Session
  alias Ideas.Meetup.Idea

  schema "points" do
    field :score, :integer
    # field :session_id, :id
    # field :idea_id, :id

    belongs_to :session, Session
    belongs_to :idea, Idea

    timestamps()
  end

  @doc false
  def changeset(%Point{} = point, attrs) do
    point
    |> cast(attrs, [:score])
    |> validate_required([:score])
  end
end
