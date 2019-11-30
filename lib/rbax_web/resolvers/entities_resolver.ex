defmodule RbaxWeb.Resolvers.EntitiesResolver do
  @moduledoc """
  The Core Resolver for Dataloader
  """

  alias Rbax.Entities

  # FINDS
  # =============================

  def subject(_, %{id: id}, _) do
    try do
      subject = Entities.get_subject!(id)
      {:ok, subject}
    rescue
      Ecto.NoResultsError ->
        {:error, "No result found"}
    end
  end

  def role(_, %{id: id}, _) do
    try do
      role = Entities.get_role!(id)
      {:ok, role}
    rescue
      Ecto.NoResultsError ->
        {:error, "No result found"}
    end
  end

  def context(_, %{id: id}, _) do
    try do
      context = Entities.get_context!(id)
      {:ok, context}
    rescue
      Ecto.NoResultsError ->
        {:error, "No result found"}
    end
  end

  def operation(_, %{id: id}, _) do
    try do
      operation = Entities.get_operation!(id)
      {:ok, operation}
    rescue
      Ecto.NoResultsError ->
        {:error, "No result found"}
    end
  end

  def right(_, %{id: id}, _) do
    try do
      right = Entities.get_right!(id)
      {:ok, right}
    rescue
      Ecto.NoResultsError ->
        {:error, "No result found"}
    end
  end

  def domain(_, %{id: id}, _) do
    try do
      domain = Entities.get_domain!(id)
      {:ok, domain}
    rescue
      Ecto.NoResultsError ->
        {:error, "No result found"}
    end
  end

  def resource(_, %{id: id}, _) do
    try do
      resource = Entities.get_resource!(id)
      {:ok, resource}
    rescue
      Ecto.NoResultsError ->
        {:error, "No result found"}
    end
  end

  def permission(_, %{id: id}, _) do
    try do
      permission = Entities.get_permission!(id)
      {:ok, permission}
    rescue
      Ecto.NoResultsError ->
        {:error, "No result found"}
    end
  end

  # LISTS
  # =============================

  def subjects(_, args, _) do
    {:ok, Entities.list_subjects(args)}
  end

  def roles(_, args, _) do
    {:ok, Entities.list_roles(args)}
  end

  def contexts(_, args, _) do
    {:ok, Entities.list_contexts(args)}
  end

  def operations(_, args, _) do
    {:ok, Entities.list_operations(args)}
  end

  def rights(_, args, _) do
    {:ok, Entities.list_rights(args)}
  end

  def domains(_, args, _) do
    {:ok, Entities.list_domains(args)}
  end

  def resources(_, args, _) do
    {:ok, Entities.list_resources(args)}
  end

  def permissions(_, _args, _) do
    {:ok, Entities.list_permissions()}
  end
end
