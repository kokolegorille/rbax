defmodule RbaxWeb.Rbax.RoleController do
  use RbaxWeb, :controller

  alias Rbax.Entities
  alias Entities.Role

  plug :authenticate

  def index(conn, _params) do
    roles =  Entities.list_roles(order: :asc)
    |> preload_subjects()
    render(conn, "index.html", roles: roles)
  end

  def show(conn, %{"id" => id}) do
    with %Role{} = role <- Entities.get_role!(id) do
      render(conn, "show.html", role: preload_subjects(role))
    else
      nil ->
        conn
        |> put_flash(:error, gettext("Role not found."))
        |> redirect(to: Routes.role_path(conn, :index))
    end
  end

  def new(conn, _params) do
    subjects = Entities.list_subjects()
    changeset = Role.changeset(
      preload_subjects(%Role{})
    )
    render(conn, "new.html", changeset: changeset, subjects: subjects)
  end

  def create(conn, %{"role" => role_params}) do
    with {:ok, role} <- Entities.create_role(role_params) do
      conn
        |> put_flash(:info, gettext("Role created successfully."))
        |> redirect(to: Routes.role_path(conn, :show, role))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        data = preload_subjects(changeset.data)
        subjects = Entities.list_subjects()
        render(conn, "new.html", changeset: %{changeset | data: data}, subjects: subjects)
    end
  end

  def edit(conn, %{"id" => id}) do
    role = id |> Entities.get_role!() |> preload_subjects()

    changeset = Entities.change_role(role)
    subjects = Entities.list_subjects()
    render(conn, "edit.html", role: role, changeset: changeset, subjects: subjects)
  end

  def update(conn, %{"id" => id, "role" => role_params}) do
    role = id |> Entities.get_role!() |> preload_subjects()

    case Entities.update_role(role, role_params) do
      {:ok, role} ->
        conn
        |> put_flash(:info, gettext("Role updated successfully."))
        |> redirect(to: Routes.role_path(conn, :show, role))

      {:error, %Ecto.Changeset{} = changeset} ->
        data = preload_subjects(changeset.data)
        subjects = Entities.list_subjects()
        render(conn, "edit.html",
          role: role,
          changeset: %{changeset | data: data},
          subjects: subjects
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    role = Entities.get_role!(id)
    {:ok, _role} = Entities.delete_role(role)

    conn
    |> put_flash(:info, gettext("Role deleted successfully."))
    |> redirect(to: Routes.role_path(conn, :index))
  end

  # Private

  defp preload_subjects(any), do: Rbax.Repo.preload(any, :subjects)
end
