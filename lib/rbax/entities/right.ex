defmodule Rbax.Entities.Right do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rbax.Entities.Operation

  schema "rights" do
    field :name, :string
    field :filter, :string
    many_to_many :operations, Operation, join_through: "operation_right", on_replace: :delete
    has_many :permissions, through: [:operations, :permissions]
    timestamps()
  end

  @allowed_fields ~w(name filter)a

  def changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, @allowed_fields)
    |> validate_required([:name])
    |> unique_constraint(:name, message: "Name already taken")
  end
end
