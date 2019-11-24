defmodule Rbax.Entities.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rbax.Entities.{Subject, Permission}

  schema "roles" do
    field :name, :string
    many_to_many :subjects, Subject, join_through: "subject_role", on_replace: :delete
    has_many :permissions, Permission
    timestamps()
  end

  @allowed_fields [:name]

  def changeset(%__MODULE__{} = role, params \\ %{}) do
    role
    |> Ecto.Changeset.cast(params, @allowed_fields)
    |> validate_required([:name])
    |> unique_constraint(:name, message: "Name already taken")
  end
end
