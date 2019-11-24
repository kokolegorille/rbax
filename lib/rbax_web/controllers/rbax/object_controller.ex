defmodule RbaxWeb.Rbax.ObjectController do
  use RbaxWeb, :controller

  alias Rbax.Entities
  alias Entities.Object

  def index(conn, _params) do
    objects =  Entities.list_objects()
    render(conn, "index.html", objects: objects)
  end

  def show(conn, %{"id" => id}) do
    with %Object{} = object <- Entities.get_object!(id) do
      render(conn, "show.html", object: object)
    else
      nil ->
        conn
        |> put_flash(:error, gettext("Object not found."))
        |> redirect(to: Routes.object_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Object.changeset(%Object{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"object" => object_params}) do
    with {:ok, object} <- Entities.create_object(object_params) do
      conn
        |> put_flash(:info, gettext("Object created successfully."))
        |> redirect(to: Routes.object_path(conn, :show, object))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    object = Entities.get_object!(id)
    changeset = Entities.change_object(object)
    render(conn, "edit.html", object: object, changeset: changeset)
  end

  def update(conn, %{"id" => id, "object" => object_params}) do
    object = Entities.get_object!(id)

    case Entities.update_object(object, object_params) do
      {:ok, object} ->
        conn
        |> put_flash(:info, gettext("Object updated successfully."))
        |> redirect(to: Routes.object_path(conn, :show, object))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", object: object, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    object = Entities.get_object!(id)
    {:ok, _object} = Entities.delete_object(object)

    conn
    |> put_flash(:info, gettext("Object deleted successfully."))
    |> redirect(to: Routes.object_path(conn, :index))
  end
end
