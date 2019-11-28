defmodule RbaxWeb.Helpers.DebugHelper do
  alias RbaxWeb.Rbax.DebugView
  alias Rbax.Engine

  def rbax_debug(s, object_or_resource_name) do
    # IO.inspect {s, object_or_resource_name, s == object_or_resource_name}
    # subject = Repo.preload(s, :permissions)

    # permissions = Engine.permissions_for(subject, object_or_resource_name)
    # |> IO.inspect(label: "PPP")

    permissions = Engine.permissions_for(s, object_or_resource_name)
    rights = Engine.rights_for(s, object_or_resource_name)

    args = [
      current_user: s,
      resource: object_or_resource_name,
      permissions: permissions,
      rights: rights,
    ]
    render "show.html", args
  end

  defp render(template, params) do
    DebugView.render(template, params)
  end
end
