defmodule Liveflow.Repo.Migrations.CreateNodes do
  use Ecto.Migration

  def change do
    create table(:nodes) do
      add :node_type, :string
      add :label, :string
      add :position_x, :float
      add :position_y, :float
      add :width, :float
      add :height, :float
      add :data, :map
      add :style, :map
      add :workflow_id, references(:workflows, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:nodes, [:workflow_id])
  end
end
