defmodule Rbax.Entities.Context do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rbax.Entities.Permission

  schema "contexts" do
    field :name, :string
    field :rule, :string
    field :filter, :string
    has_many(:permissions, Permission)
    timestamps()
  end

  @allowed_fields ~w(name rule filter)a

  def changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, @allowed_fields)
    |> validate_required([:name])
    |> unique_constraint(:name, message: "Name already taken")
  end
end
