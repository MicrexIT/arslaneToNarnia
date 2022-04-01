
defmodule ArslaneToNarniaWeb.ProjectPublicLive.FormComponent do
  use ArslaneToNarniaWeb, :live_component

  alias ArslaneToNarnia.Projects
  alias ArslaneToNarnia.Projects.{ProjectProposal}
  alias ArslaneToNarnia.Accounts.{User}

  # def mount(%{project: project} = assigns, socket) do
  #   changeset = Projects.change_project(project)

  #   {:ok,
  #    socket
  #    |> assign(assigns)
  #    |> allow_upload(:project_uploads,
  #      auto_upload: true,
  #      accept: ~w(.png .jpeg .jpg),
  #      max_entries: 10
  #    )
  #    |> assign(:changeset, changeset)}
  # end

  @impl true
  def update(%{project_proposal: project, current_user: current_user} = assigns, socket) do
    changeset = Projects.change_project_proposal(project)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:current_user, current_user)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"project_proposal" => project_params}, socket) do
    changeset =
      socket.assigns.project_proposal
      |> Projects.change_project_proposal(project_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"project_proposal" => project_params}, socket) do
    save_project(socket, socket.assigns.action, project_params)
  end

  defp save_project(socket, :new, project_params) do
    IO.inspect(socket)
    case Projects.propose_project(socket.assigns.current_user, socket.assigns.project_proposal, project_params) do
      {:ok, _project} ->
        {:noreply,
         socket
         |> put_flash(:info, "Project proposed successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

end
