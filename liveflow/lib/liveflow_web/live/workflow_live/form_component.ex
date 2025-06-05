defmodule LiveflowWeb.WorkflowLive.FormComponent do
  use LiveflowWeb, :live_component

  alias Liveflow.Workflows

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage workflow records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="workflow-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:created_by]} type="text" label="Created by" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Workflow</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{workflow: workflow} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Workflows.change_workflow(workflow))
     end)}
  end

  @impl true
  def handle_event("validate", %{"workflow" => workflow_params}, socket) do
    changeset = Workflows.change_workflow(socket.assigns.workflow, workflow_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"workflow" => workflow_params}, socket) do
    save_workflow(socket, socket.assigns.action, workflow_params)
  end

  defp save_workflow(socket, :edit, workflow_params) do
    case Workflows.update_workflow(socket.assigns.workflow, workflow_params) do
      {:ok, workflow} ->
        notify_parent({:saved, workflow})

        {:noreply,
         socket
         |> put_flash(:info, "Workflow updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_workflow(socket, :new, workflow_params) do
    case Workflows.create_workflow(workflow_params) do
      {:ok, workflow} ->
        notify_parent({:saved, workflow})

        {:noreply,
         socket
         |> put_flash(:info, "Workflow created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
