defmodule Ideas.Meetup.Session do
  @moduledoc """
  The Session schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Ideas.Meetup.Session
  alias Ideas.Meetup.Point
  alias Ideas.Meetup.Idea

  schema "sessions" do
    field(:name, :string)

    has_many(:points, Point)
    many_to_many(:ideas, Idea, join_through: "points")

    timestamps()
  end

  @doc false
  def changeset(%Session{} = session, attrs) do
    session
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
