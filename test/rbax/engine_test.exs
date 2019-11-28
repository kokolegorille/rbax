defmodule Rbax.EngineTest do
  use ExUnit.Case
  use Rbax.DataCase

  alias Rbax.Mock.Seeds
  alias Rbax.{Engine, Entities}
  alias Entities.{Subject, Permission}

  @rbax_resources [
    "Subject", "Role", "Context", "Operation", "Right",
    "Domain", "Resource", "Permission"
  ]
  @manage_rights ["create", "read", "update", "delete"]

  # Loading seeds will slow down tests!
  setup do
    Seeds.seed!
    {:ok, []}
  end

  describe "Engine setup" do
    test "there are some datas" do
      assert length(Entities.list_subjects) > 0
    end

    test "admin can do all" do
      assert %Subject{} = subject = Entities.get_subject_by_name("admin")
      resource_names = Engine.readable_resources(subject)
      |> Enum.map(& &1.name)
      # |> IO.inspect()

      # lists can have different order!
      assert resource_names -- @rbax_resources == []

      # Chack that all rbax resources contains manage rights
      group_of_rights = resource_names
      |> Enum.map(fn resource ->
        Engine.rights_for(subject, resource)
        |> Enum.map(& &1.name)
      end)
      # IO.inspect group_of_rights

      assert Enum.all?(group_of_rights, fn right_names ->
        right_names -- @manage_rights == []
      end)
    end
  end

  describe "self_permission" do
    setup do
      create_permission("thehobbits", "self", "manage", "Rbax")
      {:ok, []}
    end

    test "can? on self" do
      bilbo = Entities.get_subject_by_name "bilbo"

      assert Engine.can?(bilbo, "Subject", :show, bilbo)
      assert Engine.can?(bilbo, "Subject", :index, nil)
      assert Engine.can?(bilbo, "Subject", :update, bilbo)
      assert Engine.can?(bilbo, "Subject", :delete, bilbo)

      # TODO: should NOT! But manage gives it...
      # -> add an operation with :read, :update, but not :create, nor :delete
      assert Engine.can?(bilbo, "Subject", :create, nil)
    end

    test "cannot? on not self" do
      bilbo = Entities.get_subject_by_name "bilbo"
      frodo = Entities.get_subject_by_name "frodo"

      refute Engine.can?(bilbo, "Subject", :show, frodo)
      refute Engine.can?(bilbo, "Subject", :update, frodo)
      refute Engine.can?(bilbo, "Subject", :delete, frodo)
    end
  end

  # PRIVATE

  defp create_permission(role_name, context_name, operation_name, domain_name) do
    role = Entities.get_role_by_name role_name
    context = Entities.get_context_by_name context_name
    operation = Entities.get_operation_by_name operation_name
    domain = Entities.get_domain_by_name domain_name

    Ecto.Changeset.change(%Permission{})
    |> put_assoc(:role, role)
    |> put_assoc(:context, context)
    |> put_assoc(:operation, operation)
    |> put_assoc(:domain, domain)
    |> Repo.insert!
  end
end
