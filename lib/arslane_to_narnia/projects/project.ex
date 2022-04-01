defmodule ArslaneToNarnia.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :description, :string
    field :category, Ecto.Enum, values: [:recurring, :one_off]
    field :status, Ecto.Enum, values: [:draft, :ongoing, :completed, :on_hold], default: :draft
    field :title, :string
    field :where, :string
    field :pictures, {:array, :string}, default: []
    field :main_picture, :string

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:title, :where, :description, :category, :status, :main_picture])
    |> validate_required([:title, :where, :description, :category, :status])
    |> validate_required([:title, :where, :description, :category, :status])
  end

  def put_main_picture(%Ecto.Changeset{} = changeset, [url | _]) do
    changeset
    |> Ecto.Changeset.change(%{main_picture: url})
  end

  def put_main_picture(%Ecto.Changeset{} = changeset, _urls), do: changeset
end
