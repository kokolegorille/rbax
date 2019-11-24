defmodule Rbax.Entities.Subject do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rbax.Entities.Role

  schema "subjects" do
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    many_to_many :roles, Role, join_through: "subject_role", on_replace: :delete
    has_many :permissions, through: [:roles, :permissions]
    timestamps()
  end

  @allowed_fields ~w(name)a
  @registration_fields ~w(password)a

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, @allowed_fields)
    |> validate_required([:name])
    |> unique_constraint(:name, message: "Name already taken")
  end

  def registration_changeset(struct, attrs) do
    struct
    |> changeset(attrs)
    |> cast(attrs, @registration_fields)
    |> validate_required(@registration_fields)
    |> validate_length(:password, min: 6, max: 32)
    |> generate_encrypted_password()
  end

  defp generate_encrypted_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(password))
      _ ->
        changeset
    end
  end
end
