defmodule Rbax.Mock.Seeds do
  alias Rbax.{Repo, Entities}
  alias Entities.{
    Subject, Role,
    Context,
    Operation, Right,
    Domain, Object,
    # Permission
  }

  def seed! do
    Repo.transaction(fn ->
      _subjects =
        mock_subjects()
        |> Enum.map(fn subject ->
          create_subject!(subject)
        end)
      _roles =
        mock_roles()
        |> Enum.map(fn role ->
          create_role!(role)
        end)
      _contexts =
        mock_contexts()
        |> Enum.map(fn context ->
          create_context!(context)
        end)
      _operations =
        mock_operations()
        |> Enum.map(fn operation ->
          create_operation!(operation)
        end)
      _rights =
        mock_rights()
        |> Enum.map(fn right ->
          create_right!(right)
        end)
      _domains =
        mock_domains()
        |> Enum.map(fn domain ->
          create_domain!(domain)
        end)
      _objects =
        mock_objects()
        |> Enum.map(fn object ->
          create_object!(object)
        end)
    end)
  end

  def create_subject!(params) do
    %Subject{}
    |> Subject.changeset(params)
    |> Repo.insert!()
  end

  def create_role!(params) do
    %Role{}
    |> Role.changeset(params)
    |> Repo.insert!()
  end

  def create_context!(params) do
    %Context{}
    |> Context.changeset(params)
    |> Repo.insert!()
  end

  def create_operation!(params) do
    %Operation{}
    |> Operation.changeset(params)
    |> Repo.insert!()
  end

  def create_right!(params) do
    %Right{}
    |> Right.changeset(params)
    |> Repo.insert!()
  end

  def create_domain!(params) do
    %Domain{}
    |> Domain.changeset(params)
    |> Repo.insert!()
  end

  def create_object!(params) do
    %Object{}
    |> Object.changeset(params)
    |> Repo.insert!()
  end

  # Private

  defp mock_subjects do
    [
      %{name: "kiki"},
      %{name: "koko"},
      %{name: "kuku"},
    ]
  end

  defp mock_roles do
    [
      %{name: "admin"},
      %{name: "user"},
      %{name: "guest"},
    ]
  end

  defp mock_contexts do
    [
      %{name: "default"},
      %{name: "owner", rule: "s.id == o.owner_id"},
      %{name: "self", rule: "s == o"},
    ]
  end

  defp mock_operations do
    [
      %{name: "manage"},
    ]
  end

  defp mock_rights do
    [
      %{name: "read"},
      %{name: "write"},
      %{name: "delete"},
    ]
  end

  defp mock_domains do
    [
      %{name: "rbax"},
    ]
  end

  defp mock_objects do
    [
      %{name: "Subject"},
      %{name: "Role"},
      %{name: "Context"},
      %{name: "Operation"},
      %{name: "Right"},
      %{name: "Domain"},
      %{name: "Object"},
      %{name: "Permission"},
    ]
  end
end

# iex> operation = Rbax.get_operation! 1
# iex> rights = Rbax.list_rights
# iex> rights |> Enum.map(&Rbax.link_operation_right(operation, &1))

# iex> domain = Rbax.get_domain! 1
# iex> objects = Rbax.list_objects
# iex> objects |> Enum.map(&Rbax.link_domain_object(domain, &1))
