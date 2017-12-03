defmodule Ideas.Repo.Migrations.CreatePoints do
  use Ecto.Migration

  def change do
    create table(:points) do
      add(:score, :integer)
      add(:session_id, references(:sessions, on_delete: :nothing))
      add(:idea_id, references(:ideas, on_delete: :nothing))

      timestamps()
    end

    create(index(:points, [:session_id]))
    create(index(:points, [:idea_id]))

    create(unique_index(:points, [:session_id, :idea_id]))
  end
end
