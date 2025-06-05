defmodule Liveflow.Seeds do
  @moduledoc """
  Seed data for demonstrating workflow functionality.
  """

  alias Liveflow.Workflows

  def seed_demo_workflow do
    # Create a sample workflow
    {:ok, workflow} =
      Workflows.create_workflow(%{
        name: "Sample E-commerce Order Process",
        description: "A demo workflow showing an e-commerce order processing pipeline",
        created_by: "demo_user",
        canvas_data: %{
          viewport: %{x: 0, y: 0, zoom: 1}
        }
      })

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
        style: %{backgroundColor: "#ecfdf5", border: "2px solid #10b981", borderRadius: "8px"}
      })

    {:ok, validation_node} =
      Workflows.create_node(%{
        workflow_id: workflow.id,
        node_type: "process",
        label: "Validate Order",
        position_x: 300.0,
        position_y: 100.0,
        width: 140.0,
        height: 80.0,
        data: %{description: "Check inventory and payment"},
        style: %{backgroundColor: "#fef3c7", border: "2px solid #f59e0b", borderRadius: "8px"}
      })

    {:ok, decision_node} =
      Workflows.create_node(%{
        workflow_id: workflow.id,
        node_type: "decision",
        label: "Order Valid?",
        position_x: 520.0,
        position_y: 100.0,
        width: 120.0,
        height: 80.0,
        data: %{type: "decision"},
        style: %{backgroundColor: "#dbeafe", border: "2px solid #3b82f6", borderRadius: "8px"}
      })

    {:ok, fulfillment_node} =
      Workflows.create_node(%{
        workflow_id: workflow.id,
        node_type: "process",
        label: "Fulfill Order",
        position_x: 700.0,
        position_y: 50.0,
        width: 130.0,
        height: 70.0,
        data: %{description: "Package and ship"},
        style: %{backgroundColor: "#dcfce7", border: "2px solid #16a34a", borderRadius: "8px"}
      })

    {:ok, rejection_node} =
      Workflows.create_node(%{
        workflow_id: workflow.id,
        node_type: "process",
        label: "Reject Order",
        position_x: 700.0,
        position_y: 150.0,
        width: 130.0,
        height: 70.0,
        data: %{description: "Send rejection notice"},
        style: %{backgroundColor: "#fee2e2", border: "2px solid #dc2626", borderRadius: "8px"}
      })

    {:ok, end_node} =
      Workflows.create_node(%{
        workflow_id: workflow.id,
        node_type: "end",
        label: "Process Complete",
        position_x: 900.0,
        position_y: 100.0,
        width: 140.0,
        height: 60.0,
        data: %{},
        style: %{backgroundColor: "#f3e8ff", border: "2px solid #8b5cf6", borderRadius: "8px"}
      })

    # Create edges
    {:ok, _edge1} =
      Workflows.create_edge(%{
        workflow_id: workflow.id,
        source_node_id: start_node.id,
        target_node_id: validation_node.id,
        edge_type: "default",
        label: "",
        style: %{stroke: "#6b7280", strokeWidth: 2}
      })

    {:ok, _edge2} =
      Workflows.create_edge(%{
        workflow_id: workflow.id,
        source_node_id: validation_node.id,
        target_node_id: decision_node.id,
        edge_type: "default",
        label: "",
        style: %{stroke: "#6b7280", strokeWidth: 2}
      })

    {:ok, _edge3} =
      Workflows.create_edge(%{
        workflow_id: workflow.id,
        source_node_id: decision_node.id,
        target_node_id: fulfillment_node.id,
        edge_type: "default",
        label: "Yes",
        style: %{stroke: "#16a34a", strokeWidth: 2}
      })

    {:ok, _edge4} =
      Workflows.create_edge(%{
        workflow_id: workflow.id,
        source_node_id: decision_node.id,
        target_node_id: rejection_node.id,
        edge_type: "default",
        label: "No",
        style: %{stroke: "#dc2626", strokeWidth: 2}
      })

    {:ok, _edge5} =
      Workflows.create_edge(%{
        workflow_id: workflow.id,
        source_node_id: fulfillment_node.id,
        target_node_id: end_node.id,
        edge_type: "default",
        label: "",
        style: %{stroke: "#6b7280", strokeWidth: 2}
      })

    {:ok, _edge6} =
      Workflows.create_edge(%{
        workflow_id: workflow.id,
        source_node_id: rejection_node.id,
        target_node_id: end_node.id,
        edge_type: "default",
        label: "",
        style: %{stroke: "#6b7280", strokeWidth: 2}
      })

    # Add some node content
    {:ok, _content1} =
      Workflows.create_node_content(%{
        node_id: validation_node.id,
        content_type: "text",
        content: "Check inventory levels",
        order: 1,
        properties: %{color: "#374151"}
      })

    {:ok, _content2} =
      Workflows.create_node_content(%{
        node_id: validation_node.id,
        content_type: "text",
        content: "Verify payment method",
        order: 2,
        properties: %{color: "#374151"}
      })

    {:ok, _content3} =
      Workflows.create_node_content(%{
        node_id: fulfillment_node.id,
        content_type: "text",
        content: "Generate shipping label",
        order: 1,
        properties: %{color: "#374151"}
      })

    workflow
  end

  def seed_simple_workflow do
    # Create a simpler workflow for basic demonstration
    {:ok, workflow} =
      Workflows.create_workflow(%{
        name: "Simple Task Flow",
        description: "A basic three-step workflow",
        created_by: "demo_user",
        canvas_data: %{
          viewport: %{x: 0, y: 0, zoom: 1}
        }
      })

    # Create nodes
    {:ok, task1} =
      Workflows.create_node(%{
        workflow_id: workflow.id,
        node_type: "task",
        label: "Task 1",
        position_x: 50.0,
        position_y: 50.0,
        width: 100.0,
        height: 60.0,
        data: %{},
        style: %{backgroundColor: "#e0f2fe", border: "2px solid #0288d1", borderRadius: "6px"}
      })

    {:ok, task2} =
      Workflows.create_node(%{
        workflow_id: workflow.id,
        node_type: "task",
        label: "Task 2",
        position_x: 200.0,
        position_y: 50.0,
        width: 100.0,
        height: 60.0,
        data: %{},
        style: %{backgroundColor: "#f3e5f5", border: "2px solid #7b1fa2", borderRadius: "6px"}
      })

    {:ok, task3} =
      Workflows.create_node(%{
        workflow_id: workflow.id,
        node_type: "task",
        label: "Task 3",
        position_x: 350.0,
        position_y: 50.0,
        width: 100.0,
        height: 60.0,
        data: %{},
        style: %{backgroundColor: "#e8f5e8", border: "2px solid #388e3c", borderRadius: "6px"}
      })

    # Create edges
    {:ok, _edge1} =
      Workflows.create_edge(%{
        workflow_id: workflow.id,
        source_node_id: task1.id,
        target_node_id: task2.id,
        edge_type: "default",
        label: "",
        style: %{stroke: "#666", strokeWidth: 2}
      })

    {:ok, _edge2} =
      Workflows.create_edge(%{
        workflow_id: workflow.id,
        source_node_id: task2.id,
        target_node_id: task3.id,
        edge_type: "default",
        label: "",
        style: %{stroke: "#666", strokeWidth: 2}
      })

    workflow
  end
end
