defmodule RbaxWeb.Rbax.PermissionController do
  use RbaxWeb, :controller

  alias Rbax.Entities
  alias Entities.Permission

  def index(conn, _params) do
    permissions =  Entities.list_permissions()
    render(conn, "index.html", permissions: permissions)
  end

  def show(conn, %{"id" => id}) do
    with %Permission{} = permission <- Entities.get_permission!(id) do
      render(conn, "show.html", permission: permission)
    else
      nil ->
        conn
        |> put_flash(:error, gettext("Permission not found."))
        |> redirect(to: Routes.permission_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Permission.changeset(%Permission{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"permission" => permission_params}) do
    with {:ok, permission} <- Entities.create_permission(permission_params) do
      conn
        |> put_flash(:info, gettext("Permission created successfully."))
        |> redirect(to: Routes.permission_path(conn, :show, permission))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    permission = Entities.get_permission!(id)
    changeset = Entities.change_permission(permission)
    render(conn, "edit.html", permission: permission, changeset: changeset)
  end

  def update(conn, %{"id" => id, "permission" => permission_params}) do
    permission = Entities.get_permission!(id)

    case Entities.update_permission(permission, permission_params) do
      {:ok, permission} ->
        conn
        |> put_flash(:info, gettext("Permission updated successfully."))
        |> redirect(to: Routes.permission_path(conn, :show, permission))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", permission: permission, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    permission = Entities.get_permission!(id)
    {:ok, _permission} = Entities.delete_permission(permission)

    conn
    |> put_flash(:info, gettext("Permission deleted successfully."))
    |> redirect(to: Routes.permission_path(conn, :index))
  end
end
