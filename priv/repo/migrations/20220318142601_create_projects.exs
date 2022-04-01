defmodule ArslaneToNarnia.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :title, :string
      add :where, :string
      add :category, :string
      add :status, :string
      add :description, :text
      add :pictures, {:array, :text}, default: []
      add :main_picture, :text
      timestamps()
    end
  end
end
