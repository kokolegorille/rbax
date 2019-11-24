defmodule Rbax.Entities.Permission do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rbax.Entities.{Role, Context, Operation, Domain}

  schema "permissions" do
    belongs_to :role, Role
    belongs_to :context, Context
    belongs_to :operation, Operation
    belongs_to :domain, Domain

    timestamps()
  end

  @allowed_fields [:role_id, :context_id, :operation_id, :domain_id]

  def changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, @allowed_fields)
    |> validate_required([:role_id, :context_id, :operation_id, :domain_id])
  end
end
