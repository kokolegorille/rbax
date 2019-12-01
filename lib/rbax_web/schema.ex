defmodule RbaxWeb.Schema do
  use Absinthe.Schema

  use Absinthe.Relay.Schema, :modern

  require Logger

  # Include date type
  import_types Absinthe.Type.Custom
  import_types __MODULE__.EntitiesTypes

  alias RbaxWeb.Resolvers
  alias Rbax.Entities

  alias Entities.{
    Subject, Role, Context, Operation, Right,
    Domain, Resource, Permission
  }

  node interface do
    resolve_type fn
      %Subject{}, _ ->
        :subject
      %Role{}, _ ->
        :role
      %Context{}, _ ->
        :context
      %Operation{}, _ ->
        :operation
      %Right{}, _ ->
        :right
      %Domain{}, _ ->
        :domain
      %Resource{}, _ ->
        :resource
      %Permission{}, _ ->
        :permission
      _, _ ->
        nil
    end
  end

  query do
    @desc "Get a subject by its id"
    field :subject, :subject do
      arg :id, non_null(:id)
      resolve &Resolvers.EntitiesResolver.subject/3
    end

    @desc "Get a list of subjects"
    field :subjects, list_of(:subject) do
      arg :limit, :integer
      arg :offset, :integer
      arg :order, type: :sort_order, default_value: :asc
      arg :filter, :filter
      resolve &Resolvers.EntitiesResolver.subjects/3
    end

    @desc "Get a role by its id"
    field :role, :role do
      arg :id, non_null(:id)
      resolve &Resolvers.EntitiesResolver.role/3
    end

    @desc "Get a list of roles"
    field :roles, list_of(:role) do
      arg :limit, :integer
      arg :offset, :integer
      arg :order, type: :sort_order, default_value: :asc
      arg :filter, :filter
      resolve &Resolvers.EntitiesResolver.roles/3
    end

    @desc "Get a context by its id"
    field :context, :context do
      arg :id, non_null(:id)
      resolve &Resolvers.EntitiesResolver.context/3
    end

    @desc "Get a list of contexts"
    field :contexts, list_of(:context) do
      arg :limit, :integer
      arg :offset, :integer
      arg :order, type: :sort_order, default_value: :asc
      arg :filter, :filter
      resolve &Resolvers.EntitiesResolver.contexts/3
    end

    @desc "Get a operation by its id"
    field :operation, :operation do
      arg :id, non_null(:id)
      resolve &Resolvers.EntitiesResolver.operation/3
    end

    @desc "Get a list of operations"
    field :operations, list_of(:operation) do
      arg :limit, :integer
      arg :offset, :integer
      arg :order, type: :sort_order, default_value: :asc
      arg :filter, :filter
      resolve &Resolvers.EntitiesResolver.operations/3
    end

    @desc "Get a right by its id"
    field :right, :right do
      arg :id, non_null(:id)
      resolve &Resolvers.EntitiesResolver.right/3
    end

    @desc "Get a list of rights"
    field :rights, list_of(:right) do
      arg :limit, :integer
      arg :offset, :integer
      arg :order, type: :sort_order, default_value: :asc
      arg :filter, :filter
      resolve &Resolvers.EntitiesResolver.rights/3
    end

    @desc "Get a domain by its id"
    field :domain, :domain do
      arg :id, non_null(:id)
      resolve &Resolvers.EntitiesResolver.domain/3
    end

    @desc "Get a list of domains"
    field :domains, list_of(:domain) do
      arg :limit, :integer
      arg :offset, :integer
      arg :order, type: :sort_order, default_value: :asc
      arg :filter, :filter
      resolve &Resolvers.EntitiesResolver.domains/3
    end

    @desc "Get a resource by its id"
    field :resource, :resource do
      arg :id, non_null(:id)
      resolve &Resolvers.EntitiesResolver.resource/3
    end

    @desc "Get a list of resources"
    field :resources, list_of(:resource) do
      arg :limit, :integer
      arg :offset, :integer
      arg :order, type: :sort_order, default_value: :asc
      arg :filter, :filter
      resolve &Resolvers.EntitiesResolver.resources/3
    end

    @desc "Get a permission by its id"
    field :permission, :permission do
      arg :id, non_null(:id)
      resolve &Resolvers.EntitiesResolver.permission/3
    end

    @desc "Get a list of permissions"
    field :permissions, list_of(:permission) do
      arg :limit, :integer
      arg :offset, :integer
      arg :order, type: :sort_order, default_value: :asc
      resolve &Resolvers.EntitiesResolver.permissions/3
    end

    @desc "Get the currently signed-in user"
    field :me, :subject do
      resolve &Resolvers.AccountsResolver.me/3
    end
  end

  mutation do
    @desc "Create a user account"
    field :signup, :session do
      arg :name, non_null(:string)
      arg :password, non_null(:string)
      resolve &Resolvers.AccountsResolver.signup/3
    end

    @desc "Sign in a user"
    field :signin, :session do
      arg :name, non_null(:string)
      arg :password, non_null(:string)
      resolve &Resolvers.AccountsResolver.signin/3
    end
  end

  object :session do
    field :subject, non_null(:subject)
    field :token, non_null(:string)
  end

  # TYPES
  # ==============================

  enum :sort_order do
    value :asc
    value :asc_nulls_last
    value :asc_nulls_first
    value :desc
    value :desc_nulls_last
    value :desc_nulls_first
  end

  # Dataloader
  # ==============================

  def context(ctx) do
    loader =
      Dataloader.new
      |> Dataloader.add_source(Entities, Entities.datasource())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
