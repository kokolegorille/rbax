defmodule Rbax.Repo.Migrations.CreateOperationRightJoin do
  use Ecto.Migration

  def change do
    create table(:operation_right, primary_key: false) do
      add :operation_id, references(:operations, on_delete: :delete_all)
      add :right_id, references(:rights, on_delete: :delete_all)
    end
  end
end
