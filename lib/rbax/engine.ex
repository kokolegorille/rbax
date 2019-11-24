defmodule Rbax.Engine do
  alias Rbax.{Repo, Entities}
  alias Rbax.Entities.Subject

  def permissions_for_subject_on_object(%Subject{} = subject, object) do
    subject = Repo.preload(subject, :permissions)
    object_type = object.__struct__

    # TOTO : Check if ntl nil
    domain = select_domain_from_type(object_type)
    domain = Repo.preload(domain, :permissions)

    # Get the permissions intersection
    tmp = subject.permissions -- domain.permissions
    permissions = subject.permissions -- tmp

    # permissions = Repo.preload(permissions, [:role, :operation, :context, :domain])
    permissions = Repo.preload(permissions, [:operation, :context])

    # TODO : Check all context rules are true, for a given subject/object pair.

    # TODO : Cumulate operation's rights, in a unique way

    permissions
  end

  # TODO
  def can?() do

  end

  defp select_domain_from_type(_object_type) do
    # TODO : Implement 4 real
    Entities.get_domain_by_name("rbax")
  end
end
