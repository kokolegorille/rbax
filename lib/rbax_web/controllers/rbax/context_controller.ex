defmodule RbaxWeb.Rbax.ContextController do
  use RbaxWeb, :controller

  alias Rbax.Entities
  alias Entities.Context

  def index(conn, _params) do
    contexts =  Entities.list_contexts()
    render(conn, "index.html", contexts: contexts)
  end

  def show(conn, %{"id" => id}) do
    with %Context{} = context <- Entities.get_context!(id) do
      render(conn, "show.html", context: context)
    else
      nil ->
        conn
        |> put_flash(:error, gettext("Context not found."))
        |> redirect(to: Routes.context_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Context.changeset(%Context{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"context" => context_params}) do
    with {:ok, context} <- Entities.create_context(context_params) do
      conn
        |> put_flash(:info, gettext("Context created successfully."))
        |> redirect(to: Routes.context_path(conn, :show, context))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    context = Entities.get_context!(id)
    changeset = Entities.change_context(context)
    render(conn, "edit.html", context: context, changeset: changeset)
  end

  def update(conn, %{"id" => id, "context" => context_params}) do
    context = Entities.get_context!(id)

    case Entities.update_context(context, context_params) do
      {:ok, context} ->
        conn
        |> put_flash(:info, gettext("Context updated successfully."))
        |> redirect(to: Routes.context_path(conn, :show, context))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", context: context, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    context = Entities.get_context!(id)
    {:ok, _context} = Entities.delete_context(context)

    conn
    |> put_flash(:info, gettext("Context deleted successfully."))
    |> redirect(to: Routes.context_path(conn, :index))
  end
end
