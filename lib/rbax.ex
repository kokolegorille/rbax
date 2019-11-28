defmodule Rbax do
  @moduledoc """
  Rbax keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Rbax.Entities

  defdelegate list_subjects_query(criteria \\ []), to: Entities
  defdelegate list_subjects(criteria \\ []), to: Entities
  defdelegate get_subject!(id), to: Entities
  defdelegate get_subject_by_name(name), to: Entities
  defdelegate get_subjects(ids), to: Entities
  defdelegate create_subject(attrs), to: Entities
  defdelegate update_subject(subject, attrs), to: Entities
  defdelegate delete_subject(subject), to: Entities
  defdelegate change_subject(subject), to: Entities
  defdelegate registration_change_subject(subject), to: Entities

  defdelegate list_roles_query(criteria \\ []), to: Entities
  defdelegate list_roles(criteria \\ []), to: Entities
  defdelegate get_role!(id), to: Entities
  defdelegate get_role_by_name(name), to: Entities
  defdelegate get_roles(ids), to: Entities
  defdelegate create_role(attrs), to: Entities
  defdelegate update_role(role, attrs), to: Entities
  defdelegate delete_role(role), to: Entities
  defdelegate change_role(role), to: Entities
  defdelegate select_roles, to: Entities

  defdelegate list_contexts_query(criteria \\ []), to: Entities
  defdelegate list_contexts(criteria \\ []), to: Entities
  defdelegate get_context!(id), to: Entities
  defdelegate get_context_by_name(name), to: Entities
  defdelegate get_contexts(ids), to: Entities
  defdelegate create_context(attrs), to: Entities
  defdelegate update_context(context, attrs), to: Entities
  defdelegate delete_context(context), to: Entities
  defdelegate change_context(context), to: Entities
  defdelegate select_contexts, to: Entities
  #
  defdelegate fun_rule(context), to: Entities

  defdelegate list_operations_query(criteria \\ []), to: Entities
  defdelegate list_operations(criteria \\ []), to: Entities
  defdelegate get_operation!(id), to: Entities
  defdelegate get_operation_by_name(name), to: Entities
  defdelegate get_operations(ids), to: Entities
  defdelegate create_operation(attrs), to: Entities
  defdelegate update_operation(operation, attrs), to: Entities
  defdelegate delete_operation(operation), to: Entities
  defdelegate change_operation(operation), to: Entities
  defdelegate select_operations, to: Entities

  defdelegate list_rights_query(criteria \\ []), to: Entities
  defdelegate list_rights(criteria \\ []), to: Entities
  defdelegate get_right!(id), to: Entities
  defdelegate get_right_by_name(name), to: Entities
  defdelegate get_rights(ids), to: Entities
  defdelegate create_right(attrs), to: Entities
  defdelegate update_right(right, attrs), to: Entities
  defdelegate delete_right(right), to: Entities
  defdelegate change_right(right), to: Entities
  defdelegate select_domains, to: Entities

  defdelegate list_domains_query(criteria \\ []), to: Entities
  defdelegate list_domains(criteria \\ []), to: Entities
  defdelegate get_domain!(id), to: Entities
  defdelegate get_domain_by_name(name), to: Entities
  defdelegate get_domains(ids), to: Entities
  defdelegate create_domain(attrs), to: Entities
  defdelegate update_domain(domain, attrs), to: Entities
  defdelegate delete_domain(domain), to: Entities
  defdelegate change_domain(domain), to: Entities

  defdelegate list_resources_query(criteria \\ []), to: Entities
  defdelegate list_resources(criteria \\ []), to: Entities
  defdelegate get_resource!(id), to: Entities
  defdelegate get_resource_by_name(name), to: Entities
  defdelegate get_resources(ids), to: Entities
  defdelegate create_resource(attrs), to: Entities
  defdelegate update_resource(resource, attrs), to: Entities
  defdelegate delete_resource(resource), to: Entities
  defdelegate change_resource(resource), to: Entities

  defdelegate list_permissions, to: Entities
  defdelegate get_permission!(id), to: Entities
  defdelegate create_permission(attrs), to: Entities
  defdelegate update_permission(permission, attrs), to: Entities
  defdelegate delete_permission(permission), to: Entities
  defdelegate change_permission(permission), to: Entities
  #
  defdelegate pretty_print(permission), to: Entities

  ## Links
  defdelegate link_subject_role(subject, role), to: Entities
  defdelegate unlink_subject_role(subject, role), to: Entities

  defdelegate link_operation_right(operation, right), to: Entities
  defdelegate unlink_operation_right(operation, right), to: Entities

  defdelegate link_domain_resource(domain, resource), to: Entities
  defdelegate unlink_domain_resource(domain, resource), to: Entities
end
