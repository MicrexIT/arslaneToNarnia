defmodule ArslaneToNarniaWeb.ProjectPublicLive.Index do
  use ArslaneToNarniaWeb, :live_view

  alias ArslaneToNarnia.Projects
  alias ArslaneToNarnia.Projects.{Project, ProjectProposal}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :projects, list_projects())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Narnia's Projects")
    |> assign(:project, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Project")
    |> assign(:project_proposal, %ProjectProposal{})
  end

  defp list_projects do
    Projects.list_projects()
  end
end
