defmodule Rbax.Entities do
  @moduledoc """
  The Entities context.
  """

  import Ecto.Query, warn: false
  alias Rbax.Repo
  alias Rbax.Entities.{
    Subject, Role,
    Context,
    Operation, Right,
    Domain, Object,
    Permission,
  }

  ########################################
  ### SUBJECTS
  ########################################

  @doc """
  Returns the list of subjects.

  ## Examples

      iex> list_subjects()
      [%Subject{}, ...]

  """
  def list_subjects do
    Repo.all(Subject)
  end

  @doc """
  Gets a single subject.

  Raises `Ecto.NoResultsError` if the Subject does not exist.

  ## Examples

      iex> get_subject!(123)
      %Subject{}

      iex> get_subject!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subject!(id), do: Repo.get!(Subject, id)

  @doc """
  Gets a subject by name

  Returns nil if the Subject does not exist.

  ## Examples

      iex> get_subject_by_name("good_value")
      %Subject{}

      iex> get_subject_by_name("bad_value")
      nil

  """
  def get_subject_by_name(name), do: Repo.get_by(Subject, name: name)

  @doc """
  Creates a subject.

  ## Examples

      iex> create_subject(%{field: value})
      {:ok, %Subject{}}

      iex> create_subject(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subject(attrs \\ %{}) do
    %Subject{}
    |> Subject.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a subject.

  ## Examples

      iex> update_subject(subject, %{field: new_value})
      {:ok, %Subject{}}

      iex> update_subject(subject, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subject(%Subject{} = subject, attrs) do
    subject
    |> Subject.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Subject.

  ## Examples

      iex> delete_subject(subject)
      {:ok, %Subject{}}

      iex> delete_subject(subject)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subject(%Subject{} = subject) do
    Repo.delete(subject)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subject changes.

  ## Examples

      iex> change_subject(subject)
      %Ecto.Changeset{source: %Subject{}}

  """
  def change_subject(%Subject{} = subject) do
    Subject.changeset(subject, %{})
  end

  ########################################
  ### ROLES
  ########################################

  @doc """
  Returns the list of roles.

  ## Examples

      iex> list_roles()
      [%Role{}, ...]

  """
  def list_roles do
    Repo.all(Role)
  end

  @doc """
  Gets a single role.

  Raises `Ecto.NoResultsError` if the Role does not exist.

  ## Examples

      iex> get_role!(123)
      %Role{}

      iex> get_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_role!(id), do: Repo.get!(Role, id)

  @doc """
  Gets a role by name

  Returns nil if the Role does not exist.

  ## Examples

      iex> get_role_by_name("good_value")
      %Role{}

      iex> get_role_by_name("bad_value")
      nil

  """
  def get_role_by_name(name), do: Repo.get_by(Role, name: name)

  @doc """
  Creates a role.

  ## Examples

      iex> create_role(%{field: value})
      {:ok, %Role{}}

      iex> create_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a role.

  ## Examples

      iex> update_role(role, %{field: new_value})
      {:ok, %Role{}}

      iex> update_role(role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Role.

  ## Examples

      iex> delete_role(role)
      {:ok, %Role{}}

      iex> delete_role(role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.

  ## Examples

      iex> change_role(role)
      %Ecto.Changeset{source: %Role{}}

  """
  def change_role(%Role{} = role) do
    Role.changeset(role, %{})
  end

  ########################################
  ### CONTEXTS
  ########################################

  @doc """
  Returns the list of contexts.

  ## Examples

      iex> list_contexts()
      [%Context{}, ...]

  """
  def list_contexts do
    Repo.all(Context)
  end

  @doc """
  Gets a single context.

  Raises `Ecto.NoResultsError` if the Context does not exist.

  ## Examples

      iex> get_context!(123)
      %Context{}

      iex> get_context!(456)
      ** (Ecto.NoResultsError)

  """
  def get_context!(id), do: Repo.get!(Context, id)

  @doc """
  Gets a context by name

  Returns nil if the Context does not exist.

  ## Examples

      iex> get_context_by_name("good_value")
      %Context{}

      iex> get_context_by_name("bad_value")
      nil

  """
  def get_context_by_name(name), do: Repo.get_by(Context, name: name)

  @doc """
  Creates a context.

  ## Examples

      iex> create_context(%{field: value})
      {:ok, %Context{}}

      iex> create_context(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_context(attrs \\ %{}) do
    %Context{}
    |> Context.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a context.

  ## Examples

      iex> update_context(context, %{field: new_value})
      {:ok, %Context{}}

      iex> update_context(context, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_context(%Context{} = context, attrs) do
    context
    |> Context.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Context.

  ## Examples

      iex> delete_context(context)
      {:ok, %Context{}}

      iex> delete_context(context)
      {:error, %Ecto.Changeset{}}

  """
  def delete_context(%Context{} = context) do
    Repo.delete(context)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking context changes.

  ## Examples

      iex> change_context(context)
      %Ecto.Changeset{source: %Context{}}

  """
  def change_context(%Context{} = context) do
    Context.changeset(context, %{})
  end

  ########################################
  ### OPERATIONS
  ########################################

  @doc """
  Returns the list of operations.

  ## Examples

      iex> list_operations()
      [%Operation{}, ...]

  """
  def list_operations do
    Repo.all(Operation)
  end

  @doc """
  Gets a single operation.

  Raises `Ecto.NoResultsError` if the Operation does not exist.

  ## Examples

      iex> get_operation!(123)
      %Operation{}

      iex> get_operation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_operation!(id), do: Repo.get!(Operation, id)

  @doc """
  Gets an operation by name

  Returns nil if the Operation does not exist.

  ## Examples

      iex> get_operation_by_name("good_value")
      %Operation{}

      iex> get_operation_by_name("bad_value")
      nil

  """
  def get_operation_by_name(name), do: Repo.get_by(Operation, name: name)

  @doc """
  Creates a operation.

  ## Examples

      iex> create_operation(%{field: value})
      {:ok, %Operation{}}

      iex> create_operation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_operation(attrs \\ %{}) do
    %Operation{}
    |> Operation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a operation.

  ## Examples

      iex> update_operation(operation, %{field: new_value})
      {:ok, %Operation{}}

      iex> update_operation(operation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_operation(%Operation{} = operation, attrs) do
    operation
    |> Operation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Operation.

  ## Examples

      iex> delete_operation(operation)
      {:ok, %Operation{}}

      iex> delete_operation(operation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_operation(%Operation{} = operation) do
    Repo.delete(operation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking operation changes.

  ## Examples

      iex> change_operation(operation)
      %Ecto.Changeset{source: %Operation{}}

  """
  def change_operation(%Operation{} = operation) do
    Operation.changeset(operation, %{})
  end

  ########################################
  ### RIGHTS
  ########################################

  @doc """
  Returns the list of rights.

  ## Examples

      iex> list_rights()
      [%Right{}, ...]

  """
  def list_rights do
    Repo.all(Right)
  end

  @doc """
  Gets a single right.

  Raises `Ecto.NoResultsError` if the Right does not exist.

  ## Examples

      iex> get_right!(123)
      %Right{}

      iex> get_right!(456)
      ** (Ecto.NoResultsError)

  """
  def get_right!(id), do: Repo.get!(Right, id)

  @doc """
  Gets a right by name

  Returns nil if the Right does not exist.

  ## Examples

      iex> get_right_by_name("good_value")
      %Right{}

      iex> get_right_by_name("bad_value")
      nil

  """
  def get_right_by_name(name), do: Repo.get_by(Right, name: name)

  @doc """
  Creates a right.

  ## Examples

      iex> create_right(%{field: value})
      {:ok, %Right{}}

      iex> create_right(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_right(attrs \\ %{}) do
    %Right{}
    |> Right.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a right.

  ## Examples

      iex> update_right(right, %{field: new_value})
      {:ok, %Right{}}

      iex> update_right(right, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_right(%Right{} = right, attrs) do
    right
    |> Right.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Right.

  ## Examples

      iex> delete_right(right)
      {:ok, %Right{}}

      iex> delete_right(right)
      {:error, %Ecto.Changeset{}}

  """
  def delete_right(%Right{} = right) do
    Repo.delete(right)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking right changes.

  ## Examples

      iex> change_right(right)
      %Ecto.Changeset{source: %Right{}}

  """
  def change_right(%Right{} = right) do
    Right.changeset(right, %{})
  end

  ########################################
  ### DOMAINS
  ########################################

  @doc """
  Returns the list of domains.

  ## Examples

      iex> list_domains()
      [%Domain{}, ...]

  """
  def list_domains do
    Repo.all(Domain)
  end

  @doc """
  Gets a single domain.

  Raises `Ecto.NoResultsError` if the Domain does not exist.

  ## Examples

      iex> get_domain!(123)
      %Domain{}

      iex> get_domain!(456)
      ** (Ecto.NoResultsError)

  """
  def get_domain!(id), do: Repo.get!(Domain, id)

  @doc """
  Gets a domain by name

  Returns nil if the Domain does not exist.

  ## Examples

      iex> get_domain_by_name("good_value")
      %Domain{}

      iex> get_domain_by_name("bad_value")
      nil

  """
  def get_domain_by_name(name), do: Repo.get_by(Domain, name: name)

  @doc """
  Creates a domain.

  ## Examples

      iex> create_domain(%{field: value})
      {:ok, %Domain{}}

      iex> create_domain(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_domain(attrs \\ %{}) do
    %Domain{}
    |> Domain.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a domain.

  ## Examples

      iex> update_domain(domain, %{field: new_value})
      {:ok, %Domain{}}

      iex> update_domain(domain, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_domain(%Domain{} = domain, attrs) do
    domain
    |> Domain.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Domain.

  ## Examples

      iex> delete_domain(domain)
      {:ok, %Domain{}}

      iex> delete_domain(domain)
      {:error, %Ecto.Changeset{}}

  """
  def delete_domain(%Domain{} = domain) do
    Repo.delete(domain)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking domain changes.

  ## Examples

      iex> change_domain(domain)
      %Ecto.Changeset{source: %Domain{}}

  """
  def change_domain(%Domain{} = domain) do
    Domain.changeset(domain, %{})
  end

  ########################################
  ### OBJECTS
  ########################################

  @doc """
  Returns the list of objects.

  ## Examples

      iex> list_objects()
      [%Object{}, ...]

  """
  def list_objects do
    Repo.all(Object)
  end

  @doc """
  Gets a single object.

  Raises `Ecto.NoResultsError` if the Object does not exist.

  ## Examples

      iex> get_object!(123)
      %Object{}

      iex> get_object!(456)
      ** (Ecto.NoResultsError)

  """
  def get_object!(id), do: Repo.get!(Object, id)

  @doc """
  Gets a object by name

  Returns nil if the Object does not exist.

  ## Examples

      iex> get_object_by_name("good_value")
      %Object{}

      iex> get_object_by_name("bad_value")
      nil

  """
  def get_object_by_name(name), do: Repo.get_by(Object, name: name)

  @doc """
  Creates a object.

  ## Examples

      iex> create_object(%{field: value})
      {:ok, %Object{}}

      iex> create_object(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_object(attrs \\ %{}) do
    %Object{}
    |> Object.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a object.

  ## Examples

      iex> update_object(object, %{field: new_value})
      {:ok, %Object{}}

      iex> update_object(object, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_object(%Object{} = object, attrs) do
    object
    |> Object.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Object.

  ## Examples

      iex> delete_object(object)
      {:ok, %Object{}}

      iex> delete_object(object)
      {:error, %Ecto.Changeset{}}

  """
  def delete_object(%Object{} = object) do
    Repo.delete(object)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking object changes.

  ## Examples

      iex> change_object(object)
      %Ecto.Changeset{source: %Object{}}

  """
  def change_object(%Object{} = object) do
    Object.changeset(object, %{})
  end

  ########################################
  ### PERMISSIONS
  ########################################

  @doc """
  Returns the list of permissions.

  ## Examples

      iex> list_permissions()
      [%Permission{}, ...]

  """
  def list_permissions do
    Repo.all(Permission)
  end

  @doc """
  Gets a single permission.

  Raises `Ecto.NoResultsError` if the Permission does not exist.

  ## Examples

      iex> get_permission!(123)
      %Permission{}

      iex> get_permission!(456)
      ** (Ecto.NoResultsError)

  """
  def get_permission!(id), do: Repo.get!(Permission, id)

  @doc """
  Creates a permission.

  ## Examples

      iex> create_permission(%{field: value})
      {:ok, %Permission{}}

      iex> create_permission(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_permission(attrs \\ %{}) do
    %Permission{}
    |> Permission.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a permission.

  ## Examples

      iex> update_permission(permission, %{field: new_value})
      {:ok, %Permission{}}

      iex> update_permission(permission, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_permission(%Permission{} = permission, attrs) do
    permission
    |> Permission.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Permission.

  ## Examples

      iex> delete_permission(permission)
      {:ok, %Permission{}}

      iex> delete_permission(permission)
      {:error, %Ecto.Changeset{}}

  """
  def delete_permission(%Permission{} = permission) do
    Repo.delete(permission)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking permission changes.

  ## Examples

      iex> change_permission(permission)
      %Ecto.Changeset{source: %Permission{}}

  """
  def change_permission(%Permission{} = permission) do
    Permission.changeset(permission, %{})
  end

  ########################################
  ### LINKS
  ########################################

  def link_subject_role(%Subject{} = subject, %Role{} = role) do
    subject = Repo.preload(subject, :roles)
    roles = [role | subject.roles]

    subject
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_assoc(:roles, roles)
    |> Repo.update
  end

  def unlink_subject_role(%Subject{} = subject, %Role{} = role) do
    subject = Repo.preload(subject, :roles)
    roles = List.delete(subject.roles, role)

    subject
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_assoc(:roles, roles)
    |> Repo.update
  end

  def link_operation_right(%Operation{} = operation, %Right{} = right) do
    operation = Repo.preload(operation, :rights)
    rights = [right | operation.rights]

    operation
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_assoc(:rights, rights)
    |> Repo.update
  end

  def unlink_operation_right(%Operation{} = operation, %Right{} = right) do
    operation = Repo.preload(operation, :rights)
    rights = List.delete(operation.rights, right)

    operation
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_assoc(:rights, rights)
    |> Repo.update
  end

  def link_domain_object(%Domain{} = domain, %Object{} = object) do
    domain = Repo.preload(domain, :objects)
    objects = [object | domain.objects]

    domain
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_assoc(:objects, objects)
    |> Repo.update
  end

  def unlink_domain_object(%Domain{} = domain, %Object{} = object) do
    domain = Repo.preload(domain, :objects)
    objects = List.delete(domain.objects, object)

    domain
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_assoc(:objects, objects)
    |> Repo.update
  end
end
