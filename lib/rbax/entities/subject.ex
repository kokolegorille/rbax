defmodule Rbax.Entities.Subject do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rbax.Entities.Role

  schema "subjects" do
    field :name, :string
    many_to_many :roles, Role, join_through: "subject_role", on_replace: :delete
    has_many :permissions, through: [:roles, :permissions]
    timestamps()
  end

  @allowed_fields [:name]

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, @allowed_fields)
    |> validate_required([:name])
    |> unique_constraint(:name, message: "Name already taken")
  end
end
