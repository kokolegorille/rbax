defmodule Rbax.Engine do
  alias Rbax.{Repo, Entities}
  alias Entities.{Subject, Context}

  @permissions_preloads [:role, :context, domain: :objects, operation: :rights]

  def permissions_for(%Subject{} = s, o, opts \\ []) do
    get_permissions(s, o, opts)
    |> Enum.filter(fn p ->
      fun = Context.fun_rule(p.context)
      IO.inspect({s, o, p.context.rule, fun.(s, o)}, label: "CONTEXT FUNCTION VALUE")
      fun.(s, o)
    end)
  end

  def permissions_for_object(object, _opts \\ [])
  def permissions_for_object(nil, _opts), do: []
  def permissions_for_object(object, opts) when is_binary(object) do
    permissions_for_object(Entities.get_object_by_name(object), opts)
  end
  def permissions_for_object(object, opts) do
    object = object
    |> Repo.preload(permissions: @permissions_preloads)

    case Keyword.get(opts, :domain_name) do
      nil -> object.permissions
      domain_name -> permissions_for_domain_name(object.domains, domain_name)
    end
  end

  def rights_for(%Subject{} = s, o, opts \\ []) do
    permissions_for(s, o, opts)
    |> Enum.flat_map(& &1.operation.rights)
    |> Enum.uniq
  end

  def readable_objects(%Subject{} = s, readable_name \\ "read") do
    subject = Repo.preload(s, permissions: @permissions_preloads)
    subject.permissions
    |> Enum.filter(fn p -> Enum.any?(p.operation.rights, fn r -> r.name == readable_name end) end)
    |> Enum.flat_map(& &1.domain.objects)
    |> Enum.uniq
  end

  # PRIVATE

  defp get_permissions(%Subject{} = s, o, opts) do
    subject = Repo.preload(s, permissions: @permissions_preloads)

    # collect permissions for object->object
    perms = o
    |> get_object()
    |> permissions_for_object(opts)

    # Intersection of subject.permissions with perms from object, or domain
    tmp = subject.permissions -- perms
    subject.permissions -- tmp
  end

  defp permissions_for_domain_name(domains, domain_name) do
    domains
    |> Enum.filter(fn d -> d.name == domain_name || d.context == domain_name end)
    |> Repo.preload(permissions: @permissions_preloads)
    |> Enum.flat_map(& &1.permissions)
    |> Enum.uniq
  end

  defp get_object(o) do
    o.__struct__
    |> to_string
    |> String.split(".")
    |> List.last
    |> Entities.get_object_by_name()
  end
end
