defmodule ArslaneToNarniaWeb.ProjectLive.Show do
  use ArslaneToNarniaWeb, :live_view

  alias ArslaneToNarnia.Projects

  import ArslaneToNarniaWeb.AdminLayoutComponent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:project, Projects.get_project!(id))}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: Routes.project_show_path(socket, :show, socket.assigns.project))}
  end

  defp page_title(:show), do: "Show Project"
  defp page_title(:edit), do: "Edit Project"
end
