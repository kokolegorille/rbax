defmodule Rbax.Entities.Domain do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rbax.Entities.{Object, Permission}

  schema "domains" do
    field :name, :string
    field :context, :string
    many_to_many :objects, Object, join_through: "domain_object", on_replace: :delete
    has_many :permissions, Permission
    timestamps()
  end

  @allowed_fields ~w(name context)a

  def changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, @allowed_fields)
    |> validate_required([:name])
    |> unique_constraint(:name, message: "Name already taken")
  end
end
