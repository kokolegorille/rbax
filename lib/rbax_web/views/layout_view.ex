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

      # Append signout at the end!
      [signout | Enum.reverse(links)]
      |> Enum.reverse
    end
  end

  # This use Inflex for generic link
  # This can fail when path does not exists!
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
end
