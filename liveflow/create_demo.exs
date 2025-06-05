# Simple script to create demo workflow data directly
alias Liveflow.{Repo, Workflows}
alias Liveflow.Workflows.{Workflow, Node, Edge, NodeContent}

# Create a simple workflow
{:ok, workflow} =
  Workflows.create_workflow(%{
    name: "Demo E-commerce Flow",
    description: "A simple e-commerce order processing workflow for ReactFlow demonstration",
    created_by: "demo_user",
    canvas_data: %{viewport: %{x: 0, y: 0, zoom: 1}}
  })

IO.puts("Created workflow: #{workflow.name}")

# Create nodes
{:ok, start_node} =
  Workflows.create_node(%{
    workflow_id: workflow.id,
    node_type: "start",
    label: "Order Received",
    position_x: 100.0,
    position_y: 100.0,
    width: 120.0,
    height: 60.0,
    data: %{color: "#10b981"},
    style: %{backgroundColor: "#ecfdf5", border: "2px solid #10b981"}
  })

{:ok, process_node} =
  Workflows.create_node(%{
    workflow_id: workflow.id,
    node_type: "process",
    label: "Process Payment",
    position_x: 300.0,
    position_y: 100.0,
    width: 140.0,
    height: 80.0,
    data: %{description: "Validate and charge payment"},
    style: %{backgroundColor: "#fef3c7", border: "2px solid #f59e0b"}
  })

{:ok, end_node} =
  Workflows.create_node(%{
    workflow_id: workflow.id,
    node_type: "end",
    label: "Order Complete",
    position_x: 500.0,
    position_y: 100.0,
    width: 120.0,
    height: 60.0,
    data: %{},
    style: %{backgroundColor: "#f3e8ff", border: "2px solid #8b5cf6"}
  })

# Create edges
{:ok, _edge1} =
  Workflows.create_edge(%{
    workflow_id: workflow.id,
    source_node_id: start_node.id,
    target_node_id: process_node.id,
    edge_type: "default",
    style: %{stroke: "#6b7280", strokeWidth: 2}
  })

{:ok, _edge2} =
  Workflows.create_edge(%{
    workflow_id: workflow.id,
    source_node_id: process_node.id,
    target_node_id: end_node.id,
    edge_type: "default",
    style: %{stroke: "#6b7280", strokeWidth: 2}
  })

IO.puts("Demo workflow created successfully with #{workflow.id}")
IO.puts("Visit http://localhost:4000/workflows to see your workflows!")
