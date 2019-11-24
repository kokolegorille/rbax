defmodule Rbax.Entities.Operation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rbax.Entities.{Right, Permission}

  schema "operations" do
    field :name, :string
    many_to_many :rights, Right, join_through: "operation_right", on_replace: :delete
    has_many :permissions, Permission
    timestamps()
  end

  @allowed_fields ~w(name)a

  def changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, @allowed_fields)
    |> validate_required([:name])
    |> unique_constraint(:name, message: "Name already taken")
  end
end
