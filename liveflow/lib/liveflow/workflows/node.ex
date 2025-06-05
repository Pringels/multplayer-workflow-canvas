defmodule Liveflow.Workflows.Node do
  use Ecto.Schema
  import Ecto.Changeset

  alias Liveflow.Workflows.{Workflow, NodeContent, Edge}

  schema "nodes" do
    field :data, :map
    field :label, :string
    field :node_type, :string
    field :width, :float
    field :position_x, :float
    field :position_y, :float
    field :height, :float
    field :style, :map

    belongs_to :workflow, Workflow
    has_many :node_contents, NodeContent
    has_many :source_edges, Edge, foreign_key: :source_node_id
    has_many :target_edges, Edge, foreign_key: :target_node_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(node, attrs) do
    node
    |> cast(attrs, [
      :node_type,
      :label,
      :position_x,
      :position_y,
      :width,
      :height,
      :data,
      :style,
      :workflow_id
    ])
    |> validate_required([:node_type, :label, :position_x, :position_y, :workflow_id])
    |> validate_inclusion(:node_type, ["task", "decision", "start", "end", "process", "custom"])
    |> validate_length(:label, min: 1, max: 255)
    |> validate_number(:position_x, greater_than_or_equal_to: 0)
    |> validate_number(:position_y, greater_than_or_equal_to: 0)
    |> validate_number(:width, greater_than: 0)
    |> validate_number(:height, greater_than: 0)
    |> foreign_key_constraint(:workflow_id)
  end
end
