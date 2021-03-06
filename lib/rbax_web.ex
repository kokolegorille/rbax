defmodule RbaxWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use RbaxWeb, :controller
      use RbaxWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: RbaxWeb

      import Plug.Conn
      import RbaxWeb.Gettext
      alias RbaxWeb.Router.Helpers, as: Routes

      # Auth
      import RbaxWeb.Plugs.Auth, only: [authenticate: 2]

      # Rbax
      import RbaxWeb.Plugs.Rbax, only: [can?: 2]
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/rbax_web/templates",
        namespace: RbaxWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Checkbox helper
      import RbaxWeb.Helpers.CheckboxHelper

      # Debug Helper
      import RbaxWeb.Helpers.DebugHelper, only: [rbax_debug: 2]

      import RbaxWeb.ErrorHelpers
      import RbaxWeb.Gettext
      alias RbaxWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import RbaxWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
