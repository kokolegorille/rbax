defmodule RbaxWeb.Router do
  use RbaxWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RbaxWeb do
    pipe_through :browser

    get "/", PageController, :index

    scope "/rbax", Rbax do
      resources("/subjects", SubjectController)
      resources("/roles", RoleController)
      resources("/contexts", ContextController, except: [:show])
      resources("/operations", OperationController, except: [:show])
      resources("/rights", RightController, except: [:show])
      resources("/domains", DomainController)
      resources("/objects", ObjectController)
      resources("/permissions", PermissionController, except: [:show])
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", RbaxWeb do
  #   pipe_through :api
  # end
end
