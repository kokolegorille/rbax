defmodule Rbax.Mock.Seeds do
  alias Rbax.{Repo, Entities}
  alias Entities.Permission

  @pass "secret"

  def seed! do
    Repo.transaction(fn ->
      # SUBJECTS
      {:ok, admin} = Entities.create_subject(%{name: "admin", password: @pass})

      {:ok, bilbo} = Entities.create_subject(%{name: "bilbo", password: @pass})
      {:ok, frodo} = Entities.create_subject(%{name: "frodo", password: @pass})
      {:ok, samwise} = Entities.create_subject(%{name: "samwise", password: @pass})
      {:ok, meriadoc} = Entities.create_subject(%{name: "meriadoc", password: @pass})
      {:ok, peregrin} = Entities.create_subject(%{name: "peregrin", password: @pass})

      {:ok, gandalf} = Entities.create_subject(%{name: "gandalf", password: @pass})
      {:ok, aragorn} = Entities.create_subject(%{name: "aragorn", password: @pass})
      {:ok, legolas} = Entities.create_subject(%{name: "legolas", password: @pass})
      {:ok, gimli} = Entities.create_subject(%{name: "gimli", password: @pass})
      {:ok, boromir} = Entities.create_subject(%{name: "boromir", password: @pass})

      {:ok, sauron} = Entities.create_subject(%{name: "sauron", password: @pass})
      {:ok, sarumane} = Entities.create_subject(%{name: "sarumane", password: @pass})

      # Create association_ids
      admin_ids = [to_string(admin.id)]

      hobbit_ids = [
        bilbo, frodo, samwise, meriadoc, peregrin
      ] |> Enum.map(& to_string(&1.id)) |> IO.inspect(label: "HOBBITS")

      guild_ids = [
        bilbo, frodo, samwise, meriadoc, peregrin,
        gandalf, aragorn, legolas, gimli, boromir
      ] |> Enum.map(& to_string(&1.id)) |> IO.inspect(label: "GUILD")

      mordor_ids = [
        sauron, sarumane
      ] |> Enum.map(& to_string(&1.id)) |> IO.inspect(label: "MORDOR")

      # ROLES

      # Creating relations mimics web input... "key" => ["id1", "id2"]
      {:ok, administrators} = Entities.create_role(%{"name" => "administrators", "subjects" => admin_ids})
      {:ok, _thehobbits} = Entities.create_role(%{"name" => "thehobbits", "subjects" => hobbit_ids})
      {:ok, _theguild} = Entities.create_role(%{"name" => "theguild", "subjects" => guild_ids})
      {:ok, _mordor} = Entities.create_role(%{"name" => "mordor", "subjects" => mordor_ids})

      # CONTEXTS

      {:ok, default} = Entities.create_context(%{name: "default"})
      {:ok, _owner} = Entities.create_context(%{name: "owner", rule: "s.id==o.owner_id"})
      {:ok, _self} = Entities.create_context(%{name: "self", rule: "s==o"})

      # RIGHTS (CRUD)

      {:ok, create} = Entities.create_right(%{name: "create"})
      {:ok, read} = Entities.create_right(%{name: "read"})
      {:ok, update} = Entities.create_right(%{name: "update"})
      {:ok, delete} = Entities.create_right(%{name: "delete"})

      manage_ids = [
        create, read, update, delete
      ] |> Enum.map(& to_string(&1.id)) |> IO.inspect(label: "MANAGE RIGHTS")

      consult_ids = [
        read
      ] |> Enum.map(& to_string(&1.id)) |> IO.inspect(label: "MANAGE RIGHTS")

      # OPERATIONS

      {:ok, manage} = Entities.create_operation(%{"name" => "manage", "rights" => manage_ids})
      {:ok, _consult} = Entities.create_operation(%{"name" => "consult", "rights" => consult_ids})

      # OBJECTS

      {:ok, subject} = Entities.create_object(%{name: "Subject"})
      {:ok, role} = Entities.create_object(%{name: "Role"})
      {:ok, context} = Entities.create_object(%{name: "Context"})
      {:ok, operation} = Entities.create_object(%{name: "Operation"})
      {:ok, right} = Entities.create_object(%{name: "Right"})
      {:ok, domain} = Entities.create_object(%{name: "Domain"})
      {:ok, object} = Entities.create_object(%{name: "Object"})
      {:ok, permission} = Entities.create_object(%{name: "Permission"})

      # DOMAINS

      rbax_ids = [
        subject, role, context, operation, right, domain, object, permission
      ] |> Enum.map(& to_string(&1.id)) |> IO.inspect(label: "RBAX OBJECTS")

      {:ok, rbax} = Entities.create_domain(%{"name" => "Rbax", "objects" => rbax_ids})

      # PERMISSIONS

      %Permission{}
        |> Permission.changeset(%{
            role_id: administrators.id,
            context_id: default.id,
            operation_id: manage.id,
            domain_id: rbax.id
          })
        |> Repo.insert!
    end)
  end
end

