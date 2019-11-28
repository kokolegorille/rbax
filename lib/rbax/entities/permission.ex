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

  @allowed_fields ~w(role_id context_id operation_id domain_id)a

  def changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, @allowed_fields)
    |> validate_required([:role_id, :context_id, :operation_id, :domain_id])
  end

  # Permission needs to preload all!
  # [:role, :context, domain: :objects, operation: :rights]
  def pretty_print(%__MODULE__{} = permission) do
    what = permission.operation.rights
    |> Enum.map(& &1.name)
    |> Enum.join(", ")

    on = if permission.domain.context,
      do: "#{permission.domain.name} / #{permission.domain.context}",
      else: permission.domain.name

    to = permission.role.name
    when_name = if permission.context.rule,
      do: "#{permission.context.name} [ #{permission.context.rule} ]",
      else: permission.context.name

    "GRANT #{permission.operation.name} [ #{what} ] ON #{on} TO #{to} WHEN #{when_name}"
  end
end
