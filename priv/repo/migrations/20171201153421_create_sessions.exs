defmodule Ideas.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :name, :string

      timestamps()
    end

  end
end
