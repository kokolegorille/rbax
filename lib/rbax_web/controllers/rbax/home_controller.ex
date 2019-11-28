defmodule RbaxWeb.Rbax.HomeController do
  use RbaxWeb, :controller

  def not_authorized(conn, _params) do
    render(conn, "not_authorized.html")
  end
end
