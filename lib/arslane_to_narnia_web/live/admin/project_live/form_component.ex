defmodule ArslaneToNarniaWeb.ProjectLive.FormComponent do
  use ArslaneToNarniaWeb, :live_component

  alias ArslaneToNarnia.Projects
  alias ArslaneToNarnia.Projects.{Project}

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
  def update(%{project: project} = assigns, socket) do
    changeset = Projects.change_project(project)

    {:ok,
     socket
     |> assign(assigns)
     |> allow_upload(:project_uploads,
       external: &presign_entry/2,
       auto_upload: true,
       accept: ~w(.png .jpeg .jpg),
       max_entries: 10
     )
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"project" => project_params}, socket) do
    changeset =
      socket.assigns.project
      |> Projects.change_project(project_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"project" => project_params}, socket) do
    save_project(socket, socket.assigns.action, project_params)
  end

  def handle_event("cancel-entry", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :project_uploads, ref)}
  end

  defp save_project(socket, :edit, project_params) do
    project = put_uploads_urls(socket, socket.assigns.project)

    case Projects.update_project(project, project_params, &consume_uploads(socket, &1)) do
      {:ok, _project} ->
        {:noreply,
         socket
         |> put_flash(:info, "Project updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_project(socket, :new, project_params) do
    project = put_uploads_urls(socket, socket.assigns.project)

    case Projects.create_project(project, project_params, &consume_uploads(socket, &1)) do
      {:ok, _project} ->
        {:noreply,
         socket
         |> put_flash(:info, "Project created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end

  def put_uploads_urls(socket, %Project{} = project) do
    {completed, []} = uploaded_entries(socket, :project_uploads)

    urls =
      for entry <- completed do
        # Routes.static_path(socket, "/uploads/#{entry.uuid}.#{ext(entry)}")
        s3_host() |> Path.join(s3_public_key(entry))
      end

    %Project{project | pictures: urls}
  end

  def consume_uploads(socket, %Project{} = project) do
    # commit uploaded files
    # consume_uploaded_entries(socket, :project_uploads, fn meta, entry ->
    #   dest = Path.join("priv/static/uploads", "#{entry.uuid}.#{ext(entry)}")
    #   File.cp!(meta.path, dest)
    #   # {:ok, "done"}
    #   {:ok, Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")}
    # end)

    consume_uploaded_entries(socket, :project_uploads, fn _meta, _entry -> :ok end)

    IO.inspect("consumed upload returning...")
    IO.inspect(project, label: "project")

    {:ok, project}
  end

  @bucket "a2ntest"
  defp s3_host, do: "http://#{@bucket}.s3-eu-west-3.amazonaws.com"
  defp s3_key(entry), do: "#{entry.uuid}.#{ext(entry)}"
  defp s3_public_key(entry), do: "public/#{entry.uuid}.#{ext(entry)}"

  defp presign_entry(entry, socket) do
    uploads = socket.assigns.uploads
    key = s3_public_key(entry)

    config = ArslaneToNarnia.AwsUpload.get_config()

    {:ok, fields} =
      ArslaneToNarnia.AwsUpload.sign_form_upload(config, @bucket,
        key: key,
        content_type: entry.client_type,
        max_file_size: uploads.project_uploads.max_file_size,
        expires_in: :timer.hours(1)
      )

    IO.inspect(fields, label: "got fields")

    meta = %{
      uploader: "S3",
      key: key,
      url: "http://#{@bucket}.s3-#{config.region}.amazonaws.com",
      fields: fields
    }

    {:ok, meta, socket}
  end

  def upload_progress_css(progress) do
    case progress do
      x when x == 100 -> "bg-green-800 opacity-100 "
      x when x == 0 -> "bg-gray-800 opacity-100 "
      x when x > 0 -> "bg-blue-800 opacity-100 "
      _ -> "bg-gray-800 opacity-100 "
    end
  end
end
