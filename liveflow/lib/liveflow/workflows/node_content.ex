defmodule Liveflow.Workflows.NodeContent do
  use Ecto.Schema
  import Ecto.Changeset

  alias Liveflow.Workflows.Node

  schema "node_contents" do
    field :content_type, :string
    field :content, :string
    field :properties, :map
    field :order, :integer

    belongs_to :node, Node

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(node_content, attrs) do
    node_content
    |> cast(attrs, [:content_type, :content, :properties, :order, :node_id])
    |> validate_required([:content_type, :content, :order, :node_id])
    |> validate_inclusion(:content_type, [
      "text",
      "image",
      "video",
      "link",
      "form",
      "data",
      "code"
    ])
    |> validate_number(:order, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:node_id)
  end
end
