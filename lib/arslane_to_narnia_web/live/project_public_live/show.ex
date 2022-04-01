
defmodule ArslaneToNarniaWeb.ProjectPublicLive.Show do
  use ArslaneToNarniaWeb, :live_view

  alias ArslaneToNarnia.Projects

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
    {:noreply, push_patch(socket, to: Routes.project_public_show_path(socket, :show, socket.assigns.project))}
  end

  defp page_title(:show), do: "Show Project"
  defp page_title(:edit), do: "Edit Project"

  defp format_category(:recurring), do: "Recurring Project"
  defp format_category(:one_off), do: "Funded Project"

  defp format_status(:draft), do: "Project under evalutation"
  defp format_status(:ongoing), do: "Project ongoing"
  defp format_status(:completed), do: "Project completed"
  defp format_status(:on_hold), do: "Project on hold"
end
