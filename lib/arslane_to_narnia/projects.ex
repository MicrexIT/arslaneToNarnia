defmodule ArslaneToNarnia.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias ArslaneToNarnia.Repo

  alias ArslaneToNarnia.Projects.{Project, ProjectProposal}
  alias ArslaneToNarnia.Accounts.User

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects do
    Repo.all(Project)
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id), do: Repo.get!(Project, id)

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(%Project{} = project, attrs, after_save \\ &{:ok, &1}) do
    IO.inspect(project, label: "project")

    project
    |> Project.changeset(attrs)
    |> Project.put_main_picture(project.pictures)
    |> Repo.insert()
    |> after_save(after_save)

    # |> broadcast(:project_created)
  end

  def create_project(attrs), do: create_project(%Project{}, attrs)

  defp after_save({:ok, project}, func) do
    {:ok, _project} = func.(project)
  end

  defp after_save(error, _func), do: error

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs, after_save \\ &{:ok, &1}) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
    |> after_save(after_save)

    # |> broadcast(:)
  end

  @doc """
  Deletes a project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{data: %Project{}}

  """
  def change_project(%Project{} = project, attrs \\ %{}) do
    Project.changeset(project, attrs)
  end

  def change_project_proposal(%ProjectProposal{} = project, attrs \\ %{}) do
    ProjectProposal.changeset(project, attrs)
  end

  def propose_project(%User{} = user, %ProjectProposal{} = project, attrs) do
    # TODO: send email
    project
    |> ProjectProposal.changeset(attrs)
    |> ProjectProposal.put_user(user)
    |> Repo.insert()
  end
end
