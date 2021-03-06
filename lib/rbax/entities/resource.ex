defmodule Rbax.Entities.Resource do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rbax.Entities.Domain

  schema "resources" do
    field :name, :string
    many_to_many :domains, Domain, join_through: "domain_resource", on_replace: :delete
    has_many :permissions, through: [:domains, :permissions]
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
