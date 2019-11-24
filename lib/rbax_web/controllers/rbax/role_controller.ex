defmodule RbaxWeb.Rbax.RoleController do
  use RbaxWeb, :controller

  alias Rbax.Entities
  alias Entities.Role

  def index(conn, _params) do
    roles =  Entities.list_roles()
    render(conn, "index.html", roles: roles)
  end

  def show(conn, %{"id" => id}) do
    with %Role{} = role <- Entities.get_role!(id) do
      render(conn, "show.html", role: role)
    else
      nil ->
        conn
        |> put_flash(:error, gettext("Role not found."))
        |> redirect(to: Routes.role_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Role.changeset(%Role{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"role" => role_params}) do
    with {:ok, role} <- Entities.create_role(role_params) do
      conn
        |> put_flash(:info, gettext("Role created successfully."))
        |> redirect(to: Routes.role_path(conn, :show, role))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    role = Entities.get_role!(id)
    changeset = Entities.change_role(role)
    render(conn, "edit.html", role: role, changeset: changeset)
  end

  def update(conn, %{"id" => id, "role" => role_params}) do
    role = Entities.get_role!(id)

    case Entities.update_role(role, role_params) do
      {:ok, role} ->
        conn
        |> put_flash(:info, gettext("Role updated successfully."))
        |> redirect(to: Routes.role_path(conn, :show, role))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", role: role, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    role = Entities.get_role!(id)
    {:ok, _role} = Entities.delete_role(role)

    conn
    |> put_flash(:info, gettext("Role deleted successfully."))
    |> redirect(to: Routes.role_path(conn, :index))
  end
end
