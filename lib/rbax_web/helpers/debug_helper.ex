defmodule RbaxWeb.Helpers.DebugHelper do
  alias RbaxWeb.Rbax.DebugView
  alias Rbax.{Repo, Engine}

  def rbax_debug(s, object_or_string) do
    subject = Repo.preload(s, :permissions)
    permissions = Engine.permissions_for(subject, object_or_string)
    rights = Engine.rights_for(subject, object_or_string)

    args = [
      current_user: s,
      object: object_or_string,
      permissions: permissions,
      rights: rights,
    ]
    render "show.html", args
  end

  defp render(template, params) do
    DebugView.render(template, params)
  end
end
