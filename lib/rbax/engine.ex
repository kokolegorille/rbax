defmodule Rbax.Engine do
  alias Rbax.{Repo, Entities}
  alias Entities.{Subject, Context}

  def permissions_for(%Subject{} = s, o, opts \\ []) do
    subject = Repo.preload(s, permissions: [:role, :context, :domain, operation: :rights])

    # object = get_object o
    # perms = permissions_for_object(object, opts)

    perms = o
    |> get_object()
    |> permissions_for_object(opts)

    # Intersection of subject.permissions with perms from object, or domain
    tmp = subject.permissions -- perms
    all_permissions = subject.permissions -- tmp

    # filter permissions based on context rule, passing s and o as arguments
    all_permissions
    |> Enum.filter(fn p ->
      fun = Context.fun_rule(p.context)
      IO.inspect({s, o, p.context.rule, fun.(s, o)}, label: "FUN VALUE")
      fun.(s, o)
    end)
  end

  def permissions_for_object(object, _opts \\ [])
  def permissions_for_object(nil, _opts), do: []
  def permissions_for_object(object, opts) when is_binary(object) do
    permissions_for_object(Entities.get_object_by_name(object), opts)
  end
  def permissions_for_object(object, opts) do
    object = object |> Repo.preload(permissions: [:role, :context, :domain, operation: :rights])
    case Keyword.get(opts, :domain_name) do
      nil -> object.permissions
      domain_name -> permissions_for_domain_name(object.domains, domain_name)
    end
  end

  defp permissions_for_domain_name(domains, domain_name) do
    domains
    |> Enum.filter(fn d -> d.name == domain_name || d.context == domain_name end)
    |> Repo.preload(permissions: [:role, :context, :domain, operation: :rights])
    |> Enum.flat_map(& &1.permissions)
    |> Enum.uniq
  end

  def rights_for(%Subject{} = s, o, opts \\ []) do
    permissions_for(s, o, opts)
    |> Enum.flat_map(& &1.operation.rights)
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
