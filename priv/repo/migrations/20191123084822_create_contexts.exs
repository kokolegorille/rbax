defmodule Rbax.Repo.Migrations.CreateContexts do
  use Ecto.Migration

  def change do
    create table(:contexts) do
      add :name, :string, null: false
      add :rule, :string
      add :filter, :string
      timestamps()
    end
    create unique_index(:contexts, :name)
  end
end
