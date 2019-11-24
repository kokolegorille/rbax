defmodule Rbax.Repo.Migrations.CreatePermissions do
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :role_id,      references(:roles, on_delete: :delete_all), null: false
      add :context_id,   references(:contexts, on_delete: :delete_all), null: false
      add :operation_id, references(:operations, on_delete: :delete_all), null: false
      add :domain_id,    references(:domains, on_delete: :delete_all), null: false
      timestamps()
    end
  end
end
