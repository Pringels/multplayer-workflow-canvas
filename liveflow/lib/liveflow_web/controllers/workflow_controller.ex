defmodule LiveflowWeb.WorkflowController do
  use LiveflowWeb, :controller

  alias Liveflow.Workflows

  def export(conn, %{"id" => id}) do
    workflow = Workflows.get_workflow_with_canvas_data!(id)
    workflow_data = Workflows.to_reactflow_format(workflow)

    conn
    |> put_resp_content_type("application/json")
    |> put_resp_header("content-disposition", "attachment; filename=\"workflow_#{id}.json\"")
    |> json(%{
      workflow: %{
        id: workflow.id,
        name: workflow.name,
        description: workflow.description,
        created_by: workflow.created_by,
        created_at: workflow.inserted_at
      },
      canvas_data: workflow_data
    })
  end

  def import(conn, %{"workflow" => workflow_params}) do
    case Workflows.create_workflow(workflow_params) do
      {:ok, workflow} ->
        conn
        |> put_status(:created)
        |> json(%{id: workflow.id, message: "Workflow imported successfully"})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset})
    end
  end
end
