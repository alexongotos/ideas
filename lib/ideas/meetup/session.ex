defmodule Ideas.Meetup.Session do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ideas.Meetup.Session
  alias Ideas.Meetup.Point

  schema "sessions" do
    field :name, :string
    
    has_many :points, Point

    timestamps()
  end

  @doc false
  def changeset(%Session{} = session, attrs) do
    session
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
