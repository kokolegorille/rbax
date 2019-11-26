defmodule RbaxWeb.LayoutView do
  use RbaxWeb, :view
  require Logger
  alias Rbax.Engine

  def navbar(conn, nil) do
    content_tag(:ul, class: "navbar") do
      content_tag(:li) do
        link(gettext("Signin"), to: Routes.session_path(conn, :new))
      end
    end
  end

  def navbar(conn, subject) do
    content_tag(:ul, class: "navbar") do
      links = Engine.readable_objects(subject)
      |> Enum.map(& &1.name)
      |> Enum.map(& to_link(&1, conn))
      |> Enum.filter(& not is_nil(&1))

      signout = content_tag(:li) do
        link(gettext("Signout"),
          to: Routes.session_path(conn, :delete, subject),
          method: "delete",
          title: "connected as #{subject.name}")
      end

      [signout | links] |> Enum.reverse
    end
  end

  # This use Inflex for generic link
  defp to_link(object_name, conn) do
    label = Inflex.pluralize(object_name)
    path = String.to_atom("#{Inflex.underscore(object_name)}_path")
    try do
      content_tag(:li) do
        link(label, to: apply(Routes, path, [conn, :index]))
      end
    rescue
      _ ->
        Logger.warn("Invalid path : #{path}")
        nil
    end
  end

  # defp to_link("Subject", conn) do
  #   content_tag(:li) do
  #     link(gettext("Subjects"), to: Routes.subject_path(conn, :index))
  #   end
  # end

  # defp to_link("Role", conn) do
  #   content_tag(:li) do
  #     link gettext("Roles"), to: Routes.role_path(conn, :index)
  #   end
  # end

  # defp to_link("Context", conn) do
  #   content_tag(:li) do
  #     link gettext("Contexts"), to: Routes.context_path(conn, :index)
  #   end
  # end

  # defp to_link("Operation", conn) do
  #   content_tag(:li) do
  #     link gettext("Operations"), to: Routes.operation_path(conn, :index)
  #   end
  # end

  # defp to_link("Right", conn) do
  #   content_tag(:li) do
  #     link gettext("Rights"), to: Routes.right_path(conn, :index)
  #   end
  # end

  # defp to_link("Domain", conn) do
  #   content_tag(:li) do
  #     link gettext("Domains"), to: Routes.domain_path(conn, :index)
  #   end
  # end

  # defp to_link("Object", conn) do
  #   content_tag(:li) do
  #     link gettext("Objects"), to: Routes.object_path(conn, :index)
  #   end
  # end

  # defp to_link("Permission", conn) do
  #   content_tag(:li) do
  #     link gettext("Permissions"), to: Routes.permission_path(conn, :index)
  #   end
  # end

  # defp to_link(_, _conn), do: nil
end
