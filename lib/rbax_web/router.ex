defmodule RbaxWeb.Router do
  use RbaxWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    #
    plug(RbaxWeb.Plugs.Auth)
    plug(RbaxWeb.Plugs.Locale)
  end

  pipeline :api do
    plug CORSPlug, origin: "http://localhost:8080"
    plug :accepts, ["json"]
  end

  scope "/", RbaxWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources("/sessions", SessionController, only: [:new, :create, :delete])

    scope "/rbax", Rbax do
      get "/not_authorized", HomeController, :not_authorized
      #
      resources("/subjects", SubjectController)
      resources("/roles", RoleController)
      resources("/contexts", ContextController, except: [:show])
      resources("/operations", OperationController, except: [:show])
      resources("/rights", RightController, except: [:show])
      resources("/domains", DomainController)
      resources("/resources", ResourceController)
      resources("/permissions", PermissionController, except: [:show])
    end
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

  # Other scopes may use custom stacks.
  # scope "/api", RbaxWeb do
  #   pipe_through :api
  # end
end
