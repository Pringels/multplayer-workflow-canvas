defmodule Liveflow.Repo.Migrations.CreateWorkflows do
  use Ecto.Migration

  def change do
    create table(:workflows) do
      add :name, :string
      add :description, :text
      add :canvas_data, :map
      add :created_by, :string

      timestamps(type: :utc_datetime)
    end
  end
end
