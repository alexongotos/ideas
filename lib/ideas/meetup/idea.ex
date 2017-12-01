defmodule Ideas.Meetup.Idea do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ideas.Meetup.Idea


  schema "ideas" do
    field :description, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%Idea{} = idea, attrs) do
    idea
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
