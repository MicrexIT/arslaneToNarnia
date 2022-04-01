defmodule ArslaneToNarnia.ProjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ArslaneToNarnia.Projects` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        description: "some description",
        picture: "some picture",
        title: "some title",
        when: ~U[2022-03-17 14:26:00Z],
        where: "some where"
      })
      |> ArslaneToNarnia.Projects.create_project()

    project
  end
end
