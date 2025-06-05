defmodule Liveflow.Repo.Migrations.CreateEdges do
  use Ecto.Migration

  def change do
    create table(:edges) do
      add :edge_type, :string
      add :label, :string
      add :style, :map
      add :data, :map
      add :workflow_id, references(:workflows, on_delete: :nothing)
      add :source_node_id, references(:nodes, on_delete: :nothing)
      add :target_node_id, references(:nodes, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:edges, [:workflow_id])
    create index(:edges, [:source_node_id])
    create index(:edges, [:target_node_id])
  end
end
