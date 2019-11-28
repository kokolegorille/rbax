defmodule Rbax.Repo.Migrations.CreateDomainResourceJoin do
  use Ecto.Migration

  def change do
    create table(:domain_resource, primary_key: false) do
      add :domain_id, references(:domains, on_delete: :delete_all)
      add :resource_id, references(:resources, on_delete: :delete_all)
    end
  end
end
