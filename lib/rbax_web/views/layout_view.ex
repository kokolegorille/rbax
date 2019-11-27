defmodule RbaxWeb.LayoutView do
  use RbaxWeb, :view
  require Logger
  alias Rbax.Engine

  def navbar(conn, nil) do
    content_tag(:ul, class: "navbar") do
      [
        content_tag(:li) do
          link(gettext("Home"), to: "/")
        end,
        content_tag(:li) do
          link(gettext("Signin"), to: Routes.session_path(conn, :new))
        end
      ]
    end
  end

  def navbar(conn, subject) do
    content_tag(:ul, class: "navbar") do
      links = Engine.readable_objects(subject)
      |> Enum.map(& &1.name)
      |> Enum.map(& to_link(&1, conn))
      |> Enum.filter(& not is_nil(&1))

      links = [
        content_tag(:li) do
          link(gettext("Home"), to: "/")
        end | links
      ]

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
    label = pluralize(object_name)
    path = String.to_atom("#{underscore(object_name)}_path")
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

  # String Inflexion

  # Super naive implementation!
  defp pluralize(string) do
    # Inflex.pluralize string
    string <> "s"
  end

  # defp underscore(string) do
  #   Inflex.underscore string
  # end

  # defp underscore(atom) when is_atom(atom) do
  #   case Atom.to_string(atom) do
  #     "Elixir." <> rest -> underscore(rest)
  #     word -> underscore(word)
  #   end
  # end

  defp underscore(word) when is_binary(word) do
    word
    |> String.replace(~r/([A-Z]+)([A-Z][a-z])/, "\\1_\\2")
    |> String.replace(~r/([a-z\d])([A-Z])/, "\\1_\\2")
    |> String.replace(~r/-/, "_")
    |> String.downcase()
  end
end
