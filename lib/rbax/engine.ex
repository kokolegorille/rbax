defmodule Rbax.Engine do
  alias Rbax.{Repo, Entities}
  alias Entities.{Subject, Role, Context}

  @permissions_preloads [:role, :context, domain: :resources, operation: :rights]
  @guest_role "guest"
  @readable_name "read"

  def permissions_for(subject_or_nil, object_or_resource_name, opts \\ [])
  def permissions_for(%Subject{} = s, object_or_resource_name, opts) do
    get_permissions(s, object_or_resource_name, opts)
  end
  def permissions_for(nil, object_or_resource_name, opts) do
    case Entities.get_role_by_name(@guest_role) do
      nil -> []
      %Role{} = role ->
        get_permissions(role, object_or_resource_name, opts)
    end
  end

  def readable_resources(%Subject{} = s) do
    subject = preload_permissions(s)
    get_permissions_resources(subject.permissions)
  end
  def readable_resources(nil) do
    # get readable resources for guest role, if exists
    case Entities.get_role_by_name(@guest_role) do
      nil -> []
      %Role{} = role ->
        role = preload_permissions(role)
        get_permissions_resources(role.permissions)
    end
  end

  def rights_for(subject_or_nil, object_or_resource_name, opts \\ [])
  def rights_for(%Subject{} = s, object_or_resource_name, opts) do
    get_permissions(s, object_or_resource_name, opts)
    |> Enum.flat_map(& &1.operation.rights)
    |> Enum.uniq
  end
  def rights_for(nil, object_or_resource_name, opts) do
    case Entities.get_role_by_name(@guest_role) do
      nil -> []
      %Role{} = role ->
        get_permissions(role, object_or_resource_name, opts)
        |> Enum.flat_map(& &1.operation.rights)
        |> Enum.uniq
    end
  end

  def can?(subject, resource, action, object) do
    case object do
      nil ->
        # Collection actions :
        right_names = rights_for(subject, resource)
        |> Enum.map(& &1.name)
        # |> IO.inspect(label: "RIGHTS")

        case action do
          :index -> Enum.member?(right_names, "read")
          :new -> Enum.member?(right_names, "create")
          :create -> Enum.member?(right_names, "create")
          _ -> false
        end
      object ->
        right_names = rights_for(subject, object)
        |> Enum.map(& &1.name)
        # |> IO.inspect(label: "RIGHTS")

        case action do
          :show -> Enum.member?(right_names, "read")
          :edit -> Enum.member?(right_names, "update")
          :update -> Enum.member?(right_names, "update")
          :delete -> Enum.member?(right_names, "delete")
          _ -> false
        end
    end
  end

  # Private

  defp get_permissions(%Role{} = r, object_or_resource_name, opts) do
    role = preload_permissions(r)
    perms = get_object_or_resource_permissions(object_or_resource_name, opts)

    tmp = role.permissions -- perms
    permissions = role.permissions -- tmp

    # Execute context rule function if o is a struct, with nil subject
    if is_map(object_or_resource_name) do
      filter_permissions(permissions, nil, object_or_resource_name)
    else
      permissions
    end
  end

  defp get_permissions(%Subject{} = s, object_or_resource_name, opts) do
    subject = preload_permissions(s)
    perms = get_object_or_resource_permissions(object_or_resource_name, opts)

    tmp = subject.permissions -- perms
    permissions = subject.permissions -- tmp

    # Execute context rule function if o is a struct
    if is_map(object_or_resource_name) do
      filter_permissions(permissions, s, object_or_resource_name)
    else
      permissions
    end
  end

  defp get_object_or_resource_permissions(object_or_resource_name, opts) do
    case get_resource(object_or_resource_name) do
      nil -> []
      resource ->
        case Keyword.get(opts, :domain_name) do
          nil ->
            resource = preload_permissions(resource)
            resource.permissions
          domain_name ->
            case Entities.get_domain_by_name(domain_name) do
              nil ->
                []
              domain ->
                domain = Repo.preload(domain, [:resources, permissions: @permissions_preloads])
                if Enum.member?(domain.resources, resource),
                  do: domain.permissions,
                  else: []
            end
        end
    end
  end

  defp get_permissions_resources(permissions) do
    permissions
    |> Enum.filter(fn p ->
      Enum.any?(p.operation.rights, & &1.name == @readable_name)
    end)
    |> Enum.flat_map(& &1.domain.resources)
    |> Enum.uniq
  end

  defp preload_permissions(any) do
    Repo.preload(any, permissions: @permissions_preloads)
  end

  defp filter_permissions(permissions, s, o) do
    permissions
    |> Enum.filter(fn p ->
      fun = Context.fun_rule(p.context)
      fun.(s, o)
    end)
  end

  defp get_resource(object) when is_map(object) do
    object.__struct__
    |> to_string
    |> String.split(".")
    |> List.last
    |> Entities.get_resource_by_name()
  end
  defp get_resource(resource_name) when is_binary(resource_name) do
    Entities.get_resource_by_name(resource_name)
  end
end
