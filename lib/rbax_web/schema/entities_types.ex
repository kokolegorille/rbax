defmodule RbaxWeb.Schema.EntitiesTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Rbax.Repo

  use Absinthe.Relay.Schema.Notation, :modern

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  alias Rbax.Entities

  # OBJECTS
  # ==============================

  node object :subject do
    field :internal_id, :integer, do: resolve &resolve_internal_id/2
    field :name, :string

    field :roles, list_of(:role) do
      arg :limit, :integer
      arg :order, type: :sort_order, default_value: :asc
      arg :filter, :filter
      resolve dataloader(Entities)
    end

    # Timestamps
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  node object :role do
    field :internal_id, :integer, do: resolve &resolve_internal_id/2
    field :name, :string

    field :subjects, list_of(:subject) do
      arg :limit, :integer
      arg :order, type: :sort_order, default_value: :asc
      arg :filter, :filter
      resolve dataloader(Entities)
    end

    field :permissions, list_of(:permission) do
      resolve dataloader(Entities)
    end

    # Timestamps
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  node object :context do
    field :internal_id, :integer, do: resolve &resolve_internal_id/2
    field :name, :string

    field :permissions, list_of(:permission) do
      resolve dataloader(Entities)
    end

    # Timestamps
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  node object :operation do
    field :internal_id, :integer, do: resolve &resolve_internal_id/2
    field :name, :string

    field :rights, list_of(:right) do
      arg :limit, :integer
      arg :order, type: :sort_order, default_value: :asc
      arg :filter, :filter
      resolve dataloader(Entities)
    end

    field :permissions, list_of(:permission) do
      resolve dataloader(Entities)
    end

    # Timestamps
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  node object :right do
    field :internal_id, :integer, do: resolve &resolve_internal_id/2
    field :name, :string

    field :operations, list_of(:operation) do
      arg :limit, :integer
      arg :order, type: :sort_order, default_value: :asc
      arg :filter, :filter
      resolve dataloader(Entities)
    end

    # Timestamps
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  node object :domain do
    field :internal_id, :integer, do: resolve &resolve_internal_id/2
    field :name, :string

    field :resources, list_of(:resource) do
      arg :limit, :integer
      arg :order, type: :sort_order, default_value: :asc
      arg :filter, :filter
      resolve dataloader(Entities)
    end

    field :permissions, list_of(:permission) do
      resolve dataloader(Entities)
    end

    # Timestamps
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  node object :resource do
    field :internal_id, :integer, do: resolve &resolve_internal_id/2
    field :name, :string

    field :domains, list_of(:domain) do
      arg :limit, :integer
      arg :order, type: :sort_order, default_value: :asc
      arg :filter, :filter
      resolve dataloader(Entities)
    end

    # Timestamps
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  node object :permission do
    field :internal_id, :integer, do: resolve &resolve_internal_id/2
    field :role, non_null(:role), resolve: dataloader(Entities)
    field :context, non_null(:context), resolve: dataloader(Entities)
    field :operation, non_null(:operation), resolve: dataloader(Entities)
    field :domain, non_null(:domain), resolve: dataloader(Entities)
    # Timestamps
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  # INPUT OBJECT
  # ==============================

  input_object :filter do
    field :name, :string
  end

  # PRIVATE
  # ==============================

  # Extract internal id from context source
  defp resolve_internal_id(_args, %{source: source}),
    do: {:ok, source.id}
  defp resolve_internal_id(_args, _context), do: {:ok, nil}
end
