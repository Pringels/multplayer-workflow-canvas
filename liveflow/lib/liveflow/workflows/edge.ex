defmodule Liveflow.Workflows.Edge do
  use Ecto.Schema
  import Ecto.Changeset

  alias Liveflow.Workflows.{Workflow, Node}

  schema "edges" do
    field :data, :map
    field :label, :string
    field :edge_type, :string
    field :style, :map

    belongs_to :workflow, Workflow
    belongs_to :source_node, Node
    belongs_to :target_node, Node

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(edge, attrs) do
    edge
    |> cast(attrs, [
      :edge_type,
      :label,
      :style,
      :data,
      :workflow_id,
      :source_node_id,
      :target_node_id
    ])
    |> validate_required([:edge_type, :workflow_id, :source_node_id, :target_node_id])
    |> validate_inclusion(:edge_type, ["default", "straight", "step", "smoothstep", "bezier"])
    |> validate_length(:label, max: 255)
    |> validate_different_nodes()
    |> foreign_key_constraint(:workflow_id)
    |> foreign_key_constraint(:source_node_id)
    |> foreign_key_constraint(:target_node_id)
  end

  defp validate_different_nodes(changeset) do
    source_id = get_field(changeset, :source_node_id)
    target_id = get_field(changeset, :target_node_id)

    if source_id && target_id && source_id == target_id do
      add_error(changeset, :target_node_id, "cannot be the same as source node")
    else
      changeset
    end
  end
end
