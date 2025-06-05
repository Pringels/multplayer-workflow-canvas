defmodule Liveflow.Workflows do
  @moduledoc """
  The Workflows context for managing workflow canvases, nodes, edges, and content.
  """

  import Ecto.Query, warn: false
  alias Liveflow.Repo

  alias Liveflow.Workflows.{Workflow, Node, Edge, NodeContent}

  @doc """
  Returns the list of workflows.
  """
  def list_workflows do
    Repo.all(Workflow)
  end

  @doc """
  Gets a single workflow with preloaded associations.
  """
  def get_workflow!(id) do
    Workflow
    |> Repo.get!(id)
    |> Repo.preload([:nodes, :edges])
  end

  @doc """
  Gets a workflow with all its related data for canvas rendering.
  """
  def get_workflow_with_canvas_data!(id) do
    Workflow
    |> Repo.get!(id)
    |> Repo.preload(
      nodes: [:node_contents],
      edges: [:source_node, :target_node]
    )
  end

  @doc """
  Creates a workflow.
  """
  def create_workflow(attrs \\ %{}) do
    %Workflow{}
    |> Workflow.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a workflow.
  """
  def update_workflow(%Workflow{} = workflow, attrs) do
    workflow
    |> Workflow.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a workflow.
  """
  def delete_workflow(%Workflow{} = workflow) do
    Repo.delete(workflow)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workflow changes.
  """
  def change_workflow(%Workflow{} = workflow, attrs \\ %{}) do
    Workflow.changeset(workflow, attrs)
  end

  # Node functions

  @doc """
  Creates a node.
  """
  def create_node(attrs \\ %{}) do
    %Node{}
    |> Node.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a node.
  """
  def update_node(%Node{} = node, attrs) do
    node
    |> Node.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a node.
  """
  def delete_node(%Node{} = node) do
    Repo.delete(node)
  end

  @doc """
  Gets nodes for a workflow.
  """
  def list_nodes_for_workflow(workflow_id) do
    Node
    |> where([n], n.workflow_id == ^workflow_id)
    |> Repo.all()
  end

  # Edge functions

  @doc """
  Creates an edge.
  """
  def create_edge(attrs \\ %{}) do
    %Edge{}
    |> Edge.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an edge.
  """
  def update_edge(%Edge{} = edge, attrs) do
    edge
    |> Edge.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an edge.
  """
  def delete_edge(%Edge{} = edge) do
    Repo.delete(edge)
  end

  @doc """
  Gets edges for a workflow.
  """
  def list_edges_for_workflow(workflow_id) do
    Edge
    |> where([e], e.workflow_id == ^workflow_id)
    |> Repo.all()
  end

  # NodeContent functions

  @doc """
  Creates node content.
  """
  def create_node_content(attrs \\ %{}) do
    %NodeContent{}
    |> NodeContent.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates node content.
  """
  def update_node_content(%NodeContent{} = node_content, attrs) do
    node_content
    |> NodeContent.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes node content.
  """
  def delete_node_content(%NodeContent{} = node_content) do
    Repo.delete(node_content)
  end

  @doc """
  Gets node contents for a node, ordered by order field.
  """
  def list_node_contents_for_node(node_id) do
    NodeContent
    |> where([nc], nc.node_id == ^node_id)
    |> order_by([nc], nc.order)
    |> Repo.all()
  end

  @doc """
  Converts workflow data to ReactFlow format.
  """
  def to_reactflow_format(%Workflow{} = workflow) do
    workflow =
      Repo.preload(workflow, nodes: [:node_contents], edges: [:source_node, :target_node])

    nodes = Enum.map(workflow.nodes, &node_to_reactflow/1)
    edges = Enum.map(workflow.edges, &edge_to_reactflow/1)

    %{
      nodes: nodes,
      edges: edges,
      viewport: workflow.canvas_data["viewport"] || %{x: 0, y: 0, zoom: 1}
    }
  end

  defp node_to_reactflow(%Node{} = node) do
    %{
      id: to_string(node.id),
      type: node.node_type,
      position: %{x: node.position_x, y: node.position_y},
      data:
        Map.merge(node.data || %{}, %{
          label: node.label,
          contents: Enum.map(node.node_contents, &content_to_data/1)
        }),
      style: node.style || %{},
      width: node.width,
      height: node.height
    }
  end

  defp edge_to_reactflow(%Edge{} = edge) do
    %{
      id: to_string(edge.id),
      source: to_string(edge.source_node_id),
      target: to_string(edge.target_node_id),
      type: edge.edge_type,
      label: edge.label,
      style: edge.style || %{},
      data: edge.data || %{}
    }
  end

  defp content_to_data(%NodeContent{} = content) do
    %{
      id: content.id,
      type: content.content_type,
      content: content.content,
      properties: content.properties || %{},
      order: content.order
    }
  end
end
