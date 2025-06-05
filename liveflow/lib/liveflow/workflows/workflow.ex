defmodule Liveflow.Workflows.Workflow do
  use Ecto.Schema
  import Ecto.Changeset

  alias Liveflow.Workflows.{Node, Edge}

  schema "workflows" do
    field :name, :string
    field :description, :string
    field :canvas_data, :map
    field :created_by, :string

    has_many :nodes, Node
    has_many :edges, Edge

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workflow, attrs) do
    workflow
    |> cast(attrs, [:name, :description, :canvas_data, :created_by])
    |> validate_required([:name, :created_by])
    |> validate_length(:name, min: 1, max: 255)
    |> validate_length(:created_by, min: 1, max: 255)
  end
end
