defmodule Liveflow.Repo.Migrations.CreateNodeContents do
  use Ecto.Migration

  def change do
    create table(:node_contents) do
      add :content_type, :string
      add :content, :text
      add :properties, :map
      add :order, :integer
      add :node_id, references(:nodes, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:node_contents, [:node_id])
  end
end
