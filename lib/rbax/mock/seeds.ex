defmodule Rbax.Mock.Seeds do
  alias Rbax.{Repo, Entities}
  alias Entities.{
    # Subject, Role,
    # Context,
    # Operation, Right,
    # Domain, Object,
    Permission
  }

  # def seed! do
  #   Repo.transaction(fn ->
  #     _subjects =
  #       mock_subjects()
  #       |> Enum.map(fn subject ->
  #         create_subject!(subject)
  #       end)
  #     _roles =
  #       mock_roles()
  #       |> Enum.map(fn role ->
  #         create_role!(role)
  #       end)
  #     _contexts =
  #       mock_contexts()
  #       |> Enum.map(fn context ->
  #         create_context!(context)
  #       end)
  #     _operations =
  #       mock_operations()
  #       |> Enum.map(fn operation ->
  #         create_operation!(operation)
  #       end)
  #     _rights =
  #       mock_rights()
  #       |> Enum.map(fn right ->
  #         create_right!(right)
  #       end)
  #     _domains =
  #       mock_domains()
  #       |> Enum.map(fn domain ->
  #         create_domain!(domain)
  #       end)
  #     _objects =
  #       mock_objects()
  #       |> Enum.map(fn object ->
  #         create_object!(object)
  #       end)
  #   end)
  # end

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

      # DOMAINS

      rbax_ids = [
        subject, role, context, operation, right, domain, object
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
  # def create_subject!(params) do
  #   %Subject{}
  #   |> Subject.changeset(params)
  #   |> Repo.insert!()
  # end

  # def create_role!(params) do
  #   %Role{}
  #   |> Role.changeset(params)
  #   |> Repo.insert!()
  # end

  # def create_context!(params) do
  #   %Context{}
  #   |> Context.changeset(params)
  #   |> Repo.insert!()
  # end

  # def create_operation!(params) do
  #   %Operation{}
  #   |> Operation.changeset(params)
  #   |> Repo.insert!()
  # end

  # def create_right!(params) do
  #   %Right{}
  #   |> Right.changeset(params)
  #   |> Repo.insert!()
  # end

  # def create_domain!(params) do
  #   %Domain{}
  #   |> Domain.changeset(params)
  #   |> Repo.insert!()
  # end

  # def create_object!(params) do
  #   %Object{}
  #   |> Object.changeset(params)
  #   |> Repo.insert!()
  # end

  # Private

  # defp mock_subjects do
  #   [
  #     %{name: "kiki"},
  #     %{name: "koko"},
  #     %{name: "kuku"},
  #   ]
  # end

  # defp mock_roles do
  #   [
  #     %{name: "admin"},
  #     %{name: "user"},
  #     %{name: "guest"},
  #   ]
  # end

  # defp mock_contexts do
  #   [
  #     %{name: "default"},
  #     %{name: "owner", rule: "s.id == o.owner_id"},
  #     %{name: "self", rule: "s == o"},
  #   ]
  # end

  # defp mock_operations do
  #   [
  #     %{name: "manage"},
  #   ]
  # end

  # defp mock_rights do
  #   [
  #     %{name: "read"},
  #     %{name: "write"},
  #     %{name: "delete"},
  #   ]
  # end

  # defp mock_domains do
  #   [
  #     %{name: "rbax"},
  #   ]
  # end

  # defp mock_objects do
  #   [
  #     %{name: "Subject"},
  #     %{name: "Role"},
  #     %{name: "Context"},
  #     %{name: "Operation"},
  #     %{name: "Right"},
  #     %{name: "Domain"},
  #     %{name: "Object"},
  #     %{name: "Permission"},
  #   ]
  # end
end

# iex> operation = Rbax.get_operation! 1
# iex> rights = Rbax.list_rights
# iex> rights |> Enum.map(&Rbax.link_operation_right(operation, &1))

# iex> domain = Rbax.get_domain! 1
# iex> objects = Rbax.list_objects
# iex> objects |> Enum.map(&Rbax.link_domain_object(domain, &1))
