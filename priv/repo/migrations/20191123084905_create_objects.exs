defmodule Rbax.Repo.Migrations.CreateObjects do
  use Ecto.Migration

  def change do
    create table(:objects) do
      add :name, :string, null: false
      timestamps()
    end
    create unique_index(:objects, :name)
  end
end
