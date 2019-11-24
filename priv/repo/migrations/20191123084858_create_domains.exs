defmodule Rbax.Repo.Migrations.CreateDomains do
  use Ecto.Migration

  def change do
    create table(:domains) do
      add :name, :string, null: false
      timestamps()
    end
    create unique_index(:domains, :name)
  end
end
