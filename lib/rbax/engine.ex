defmodule Rbax.Engine do
  alias Rbax.{Repo, Entities}
  alias Entities.{Subject, Context}

  def permissions_for(%Subject{} = s, o, opts \\ []) do
    subject = Repo.preload(s, permissions: [:role, :context, :domain, operation: :rights])

    object = get_object o
    perms = if object do
      object = object |> Repo.preload(permissions: [:role, :context, :domain, operation: :rights])

      # Check if there is a domain_name set!
      case Keyword.get(opts, :domain_name) do
        nil ->
          object.permissions
        domain_name ->
          domains = object.domains |> Enum.filter(fn d -> d.name == domain_name || d.context == domain_name end)
          domains
          |> Repo.preload(permissions: [:role, :context, :domain, operation: :rights])
          |> Enum.flat_map(& &1.permissions)
          |> Enum.uniq
      end
    else
      []
    end

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

  def rights_for(%Subject{} = s, o, opts \\ []) do
    permissions_for(s, o, opts)
    |> Enum.flat_map(& &1.operation.rights)
    |> Enum.uniq
  end

  # Private

  defp get_object(o) do
    o.__struct__
    |> to_string
    |> String.split(".")
    |> List.last
    |> Entities.get_object_by_name()
  end

  # def permissions_for_subject_on_object(%Subject{} = subject, object) do
  #   subject = Repo.preload(subject, :permissions)
  #   object_type = object.__struct__

  #   # TOTO : Check if ntl nil
  #   domain = select_domain_from_type(object_type)
  #   domain = Repo.preload(domain, :permissions)

  #   # Get the permissions intersection
  #   tmp = subject.permissions -- domain.permissions
  #   permissions = subject.permissions -- tmp

  #   # permissions = Repo.preload(permissions, [:role, :operation, :context, :domain])
  #   permissions = Repo.preload(permissions, [:operation, :context])

  #   # TODO : Check all context rules are true, for a given subject/object pair.

  #   # TODO : Cumulate operation's rights, in a unique way

  #   permissions
  # end

  # # TODO
  # def can?(_subject, _object, _right) do

  # end

  # defp select_domain_from_type(_object_type) do
  #   # TODO : Implement 4 real
  #   Entities.get_domain_by_name("rbax")
  # end
end
