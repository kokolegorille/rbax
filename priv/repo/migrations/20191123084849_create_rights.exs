defmodule Rbax.Repo.Migrations.CreateRights do
  use Ecto.Migration

  def change do
    create table(:rights) do
      add :name, :string, null: false
      add :filter, :string
      timestamps()
    end
    create unique_index(:rights, :name)
  end
end
