defmodule ArslaneToNarnia.Projects.ProjectProposal do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArslaneToNarnia.Accounts.User

  schema "project_proposals" do
    field :description, :string
    field :category, Ecto.Enum, values: [:recurring, :one_off]
    field :title, :string
    field :where, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:title, :where, :description, :category])
    |> validate_required([:title, :description, :category])
  end

  def put_user(%Ecto.Changeset{} = changeset, %User{} = user) do
    put_assoc(changeset, :user, user)
  end

end
