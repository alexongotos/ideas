defmodule Ideas.Meetup.Idea do
  @moduledoc """
  The Idea schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Ideas.Meetup.Idea
  alias Ideas.Meetup.Point
  alias Ideas.Meetup.Session

  schema "ideas" do
    field(:description, :string)
    field(:title, :string)
    field(:score, :integer, virtual: true)

    has_many(:points, Point)
    many_to_many(:sessions, Session, join_through: "points")

    timestamps()
  end

  @doc false
  def changeset(%Idea{} = idea, attrs) do
    idea
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
