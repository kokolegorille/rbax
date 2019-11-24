defmodule Rbax.Repo.Migrations.CreateDomainObjectJoin do
  use Ecto.Migration

  def change do
    create table(:domain_object, primary_key: false) do
      add :domain_id, references(:domains, on_delete: :delete_all)
      add :object_id, references(:objects, on_delete: :delete_all)
    end
  end
end
