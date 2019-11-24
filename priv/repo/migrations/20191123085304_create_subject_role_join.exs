defmodule Rbax.Repo.Migrations.CreateSubjectRoleJoin do
  use Ecto.Migration

  def change do
    create table(:subject_role, primary_key: false) do
      add :subject_id, references(:subjects, on_delete: :delete_all)
      add :role_id, references(:roles, on_delete: :delete_all)
    end
  end
end
