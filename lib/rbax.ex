defmodule Rbax do
  @moduledoc """
  Rbax keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Rbax.Entities

  defdelegate list_subjects, to: Entities
  defdelegate get_subject!(id), to: Entities
  defdelegate get_subject_by_name(name), to: Entities
  defdelegate get_subjects(ids), to: Entities
  defdelegate create_subject(attrs), to: Entities
  defdelegate update_subject(subject, attrs), to: Entities
  defdelegate delete_subject(subject), to: Entities
  defdelegate change_subject(subject), to: Entities

  defdelegate list_roles, to: Entities
  defdelegate get_role!(id), to: Entities
  defdelegate get_role_by_name(name), to: Entities
  defdelegate get_roles(ids), to: Entities
  defdelegate create_role(attrs), to: Entities
  defdelegate update_role(role, attrs), to: Entities
  defdelegate delete_role(role), to: Entities
  defdelegate change_role(role), to: Entities

  defdelegate list_contexts, to: Entities
  defdelegate get_context!(id), to: Entities
  defdelegate get_context_by_name(name), to: Entities
  defdelegate get_contexts(ids), to: Entities
  defdelegate create_context(attrs), to: Entities
  defdelegate update_context(context, attrs), to: Entities
  defdelegate delete_context(context), to: Entities
  defdelegate change_context(context), to: Entities

  defdelegate list_operations, to: Entities
  defdelegate get_operation!(id), to: Entities
  defdelegate get_operation_by_name(name), to: Entities
  defdelegate get_operations(ids), to: Entities
  defdelegate create_operation(attrs), to: Entities
  defdelegate update_operation(operation, attrs), to: Entities
  defdelegate delete_operation(operation), to: Entities
  defdelegate change_operation(operation), to: Entities

  defdelegate list_rights, to: Entities
  defdelegate get_right!(id), to: Entities
  defdelegate get_right_by_name(name), to: Entities
  defdelegate get_rights(ids), to: Entities
  defdelegate create_right(attrs), to: Entities
  defdelegate update_right(right, attrs), to: Entities
  defdelegate delete_right(right), to: Entities
  defdelegate change_right(right), to: Entities

  defdelegate list_domains, to: Entities
  defdelegate get_domain!(id), to: Entities
  defdelegate get_domain_by_name(name), to: Entities
  defdelegate get_domains(ids), to: Entities
  defdelegate create_domain(attrs), to: Entities
  defdelegate update_domain(domain, attrs), to: Entities
  defdelegate delete_domain(domain), to: Entities
  defdelegate change_domain(domain), to: Entities

  defdelegate list_objects, to: Entities
  defdelegate get_object!(id), to: Entities
  defdelegate get_object_by_name(name), to: Entities
  defdelegate get_objects(ids), to: Entities
  defdelegate create_object(attrs), to: Entities
  defdelegate update_object(object, attrs), to: Entities
  defdelegate delete_object(object), to: Entities
  defdelegate change_object(object), to: Entities

  defdelegate list_permissions, to: Entities
  defdelegate get_permission!(id), to: Entities
  defdelegate create_permission(attrs), to: Entities
  defdelegate update_permission(permission, attrs), to: Entities
  defdelegate delete_permission(permission), to: Entities
  defdelegate change_permission(permission), to: Entities

  defdelegate link_subject_role(subject, role), to: Entities
  defdelegate unlink_subject_role(subject, role), to: Entities

  defdelegate link_operation_right(operation, right), to: Entities
  defdelegate unlink_operation_right(operation, right), to: Entities

  defdelegate link_domain_object(domain, object), to: Entities
  defdelegate unlink_domain_object(domain, object), to: Entities
end
