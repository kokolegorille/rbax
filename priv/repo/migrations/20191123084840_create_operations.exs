defmodule Rbax.Repo.Migrations.CreateOperations do
  use Ecto.Migration

  def change do
    create table(:operations) do
      add :name, :string, null: false
      timestamps()
    end
    create unique_index(:operations, :name)
  end
end
