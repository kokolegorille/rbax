defmodule Rbax.Repo.Migrations.CreateDomains do
  use Ecto.Migration

  def change do
    create table(:domains) do
      add :name, :string, null: false
      add :context, :string
      timestamps()
    end
    create unique_index(:domains, :name)
  end
end
