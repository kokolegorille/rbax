defmodule Rbax.Repo.Migrations.CreateSubjects do
  use Ecto.Migration

  def change do
    create table(:subjects) do
      add :name, :string, null: false
      timestamps()
    end
    create unique_index(:subjects, :name)
  end
end
