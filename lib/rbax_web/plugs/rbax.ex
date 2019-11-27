defmodule RbaxWeb.Plugs.Rbax do
  @moduledoc false
  import Phoenix.Controller

  def can?(conn, object) do
    subject = conn.assigns.current_user
    cname = controller_to_object(controller_module(conn))
    aname = action_name(conn)

    Rbax.Engine.can?(
      subject,
      cname,
      aname,
      object
    )
  end

  # RbaxWeb.Rbax.SubjectController
  defp controller_to_object(atom) do
    atom
    |> to_string
    |> String.split(".")
    |> List.last
    |> String.replace("Controller", "")
    |> IO.inspect(label: "CONTROLLER")
  end
end
