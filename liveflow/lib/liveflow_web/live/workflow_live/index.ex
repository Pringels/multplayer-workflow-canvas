defmodule LiveflowWeb.WorkflowLive.Index do
  use LiveflowWeb, :live_view

  alias Liveflow.Workflows
  alias Liveflow.Workflows.Workflow

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> stream(:workflows, Workflows.list_workflows()) |> assign(:counter, 0)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Workflow")
    |> assign(:workflow, Workflows.get_workflow!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Workflow")
    |> assign(:workflow, %Workflow{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Workflows")
    |> assign(:workflow, nil)
  end

  @impl true
  def handle_info({LiveflowWeb.WorkflowLive.FormComponent, {:saved, workflow}}, socket) do
    {:noreply, stream_insert(socket, :workflows, workflow)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    workflow = Workflows.get_workflow!(id)
    {:ok, _} = Workflows.delete_workflow(workflow)

    {:noreply, stream_delete(socket, :workflows, workflow)}
  end

  def handle_event("increment", %{"number" => number}, socket) do
    IO.inspect(number, label: "Incrementing by")
    {:noreply, assign(socket, :counter, number)}
  end
end
