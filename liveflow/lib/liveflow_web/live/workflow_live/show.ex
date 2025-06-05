defmodule LiveflowWeb.WorkflowLive.Show do
  use LiveflowWeb, :live_view

  alias Liveflow.Workflows

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    workflow = Workflows.get_workflow_with_canvas_data!(id)
    workflow_data = Workflows.to_reactflow_format(workflow)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:workflow, workflow)
     |> assign(:workflow_data, workflow_data)}
  end

  defp page_title(:show), do: "Show Workflow"
  defp page_title(:edit), do: "Edit Workflow"
end
