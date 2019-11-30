# Rbax

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## Dataloader

{:dataloader, "~> 1.0"}

Example
=======

iex> source = Dataloader.Ecto.new(Rbax.Repo)
iex> loader = Dataloader.new |> Dataloader.add_source(Rbax.Entities, source)
iex> subjects = Rbax.list_subjects
iex> loader = Enum.reduce(subjects, loader, fn subject, acc -> 
    Dataloader.load(acc, Rbax.Entities, :roles, subject) 
  end)
iex> loader |> Dataloader.run


# This will check context rule vs object!
# In case object is not defined, use get_permissions
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
def rights_for(s, o, _opts \\ [])
def rights_for(%Subject{} = s, o, opts) when is_binary(o) do
  # rights_for(%Subject{} = s, Entities.get_object_by_name(o), opts)
  get_permissions(s, Entities.get_object_by_name(o), opts)
  |> Enum.flat_map(& &1.operation.rights)
  |> Enum.uniq
end
def rights_for(%Subject{} = s, o, opts) do
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
def can?(subject, resource, action, object) do
  IO.inspect {subject, resource, action, object}, label: "CAN?"
  case object do
    nil ->
      # Collection actions :
      right_names = rights_for(subject, resource)
      |> Enum.map(& &1.name)
      |> IO.inspect(label: "RIGHTS")
      case action do
        :index -> Enum.member?(right_names, "read")
        :new -> Enum.member?(right_names, "create")
        :create -> Enum.member?(right_names, "create")
        _ -> false
      end
    object ->
      right_names = rights_for(subject, object)
      |> Enum.map(& &1.name)
      |> IO.inspect(label: "RIGHTS")
      case action do
        :show -> Enum.member?(right_names, "read")
        :edit -> Enum.member?(right_names, "update")
        :update -> Enum.member?(right_names, "update")
        :delete -> Enum.member?(right_names, "delete")
        _ -> false
      end
  end
end
# PRIVATE
defp get_permissions(%Subject{} = s, o, opts) do
  subject = Repo.preload(s, permissions: @permissions_preloads)
  # collect permissions for object->object
  perms = o
  |> get_object()
  |> permissions_for_object(opts)   # TODO : FIXBUG... SHOULD NOT EXECUTE RULES WHEN RESOURCE!
  # Intersection of subject.permissions with perms from object, or domain
  tmp = subject.permissions -- perms
  (subject.permissions -- tmp)
  # |> IO.inspect(label: "PERMS")
end
defp permissions_for_domain_name(domains, domain_name) do
  domains
  |> Enum.filter(fn d -> d.name == domain_name || d.context == domain_name end)
  |> Repo.preload(permissions: @permissions_preloads)
  |> Enum.flat_map(& &1.permissions)
  |> Enum.uniq
end
defp get_object(o) when is_binary(o) do
  Entities.get_object_by_name(o)
end
defp get_object(o) when is_map(o) do
  o.__struct__
  |> to_string
  |> String.split(".")
  |> List.last
  |> Entities.get_object_by_name()
end


## TRY TO EXECUTE STRING QUERY

iex(12)> Entities.list_subjects_query |> (fn q -> from o in q, where: fragment("(?).id", o) == ^s.id end).() |> Rbax.Repo.all     
[debug] QUERY OK source="subjects" db=1.4ms
SELECT s0."id", s0."name", s0."password_hash", s0."inserted_at", s0."updated_at" FROM "subjects" AS s0 WHERE ((s0).id = $1) [2]
[
  %Rbax.Entities.Subject{
    __meta__: #Ecto.Schema.Metadata<:loaded, "subjects">,
    id: 2,
    inserted_at: ~N[2019-11-28 05:37:08],
    name: "bilbo",
    password: nil,
    password_hash: "$pbkdf2-sha512$160000$j.TGj6347gYzhgJcTM7yWw$Cybfw0WwS9QHaEFiSoJW/kDy/yRRIgzuSY7AXpcVo8wPo25Km/ysZr4TDSqMSm.DvZgDvP1FdvoA8vQu3gYxCw",
    permissions: #Ecto.Association.NotLoaded<association :permissions is not loaded>,
    roles: #Ecto.Association.NotLoaded<association :roles is not loaded>,
    updated_at: ~N[2019-11-28 12:45:46]
  }
]

iex(13)> Entities.list_subjects_query |> (fn q -> from o in q, where: fragment("(?).id=(?)", o, ^id) end).() |> Rbax.Repo.all

iex(17)> Entities.list_subjects_query |> (fn q -> from o in q, where: fragment("(?).id=(?)", o, ^s.id) end).() |> Rbax.Repo.all

iex(19)> {eval, _} = Code.eval_string("s.id", s: s)
iex(20)> Entities.list_subjects_query |> (fn q -> from o in q, where: fragment("(?).id=(?)", o, ^eval) end).() |> Rbax.Repo.all
iex(29)> frodo = "frodo"
"frodo"
iex(30)> Entities.list_subjects_query |> (fn q -> from o in q, where: fragment("(?).id=(?)", o, ^eval) or fragment("(?).name=(?)", o, ^frodo) end).() |> Rbax.Repo.all


## QUESTION

Hello everyone,

I am trying to insert a dynamic filter to an ecto query.

After importing Ecto.Query in the console, I was able to run those commands.

```elixir
iex> {eval, _} = Code.eval_string("s.id", s: current_user)
iex> Entities.list_subjects_query |> (fn q -> 
  from o in q, where: fragment("(?).owner_id=(?)", o, ^eval) 
end).() |> Rbax.Repo.all
```

The idea is to filter dynamically a list, for the current user, on a list of resources, based on a filter, and bindings.

```elixir
filter = "(?).owner_id=(?)"
bindings = "s.id"
```

For context, it is an RBAC system for Phoenix, where I would like to filter resource for a given user, this example is a rule for listing only resource owned by user.

While it is working, my question is how to secure this? Because using Code.eval_string is not safe, and fragment too.

I was thinking of parsing the filter and bindings with leex/yecc... Is there an easier way?

Thanks for taking time

# Absinthe

```
# GraphQL
{:absinthe, "~> 1.4"},
{:absinthe_plug, "~> 1.4"},
{:absinthe_ecto, "~> 0.1.3"},
{:absinthe_relay, "~> 1.4"},
{:absinthe_phoenix, "~> 1.4"},
{:dataloader, "~> 1.0"},
#
{:cors_plug, "~> 2.0"},
```

* Add lib/rbax/schema.ex
* Add lib/rbax/schema/
* Add lib/rbax/schema/entities_types.ex
* Add lib/rbax/schema/accounts_types.ex

* Update router

```
  pipeline :api do
    plug CORSPlug, origin: "http://localhost:8080"
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :api

    # Note: downloaded from CDN!
    forward "/graphiql",
      Absinthe.Plug.GraphiQL,
      schema: RbaxWeb.Schema,
      json_codec: Jason #,
      # socket: RbaxWeb.UserSocket

    forward "/",
      Absinthe.Plug,
      schema: RbaxWeb.Schema,
      json_codec: Jason #,
      # socket: RbaxWeb.UserSocket
  end
```

* Update contexts

```
  def datasource() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end
```

* Update schema

```
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
```

## Sample query

{
	subjects(limit: 2) {
    name
    roles {
      name
      permissions {
        role {name}
        context {name}
        operation {
          name
          rights {
            name
          }
        }
        domain {
          name
          resources {
            name
          }
        }
      }
    }
  }
}