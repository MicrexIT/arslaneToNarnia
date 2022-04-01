defmodule ArslaneToNarnia.Repo.Migrations.AddProjectProposals do
  use Ecto.Migration

  def change do
    create table(:project_proposals) do
      add :title, :string
      add :where, :string
      add :category, :string
      add :description, :text
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps()
    end

    create index(:project_proposals, [:user_id])
  end
end
