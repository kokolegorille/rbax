defmodule RbaxWeb.Rbax.PermissionController do
  use RbaxWeb, :controller

  alias Rbax.Entities
  alias Entities.Permission

  def index(conn, _params) do
    permissions =  Entities.list_permissions()
    |> preload_associations()

    render(conn, "index.html", permissions: permissions)
  end

  # def show(conn, %{"id" => id}) do
  #   with %Permission{} = permission <- Entities.get_permission!(id) do
  #     render(conn, "show.html", permission: permission)
  #   else
  #     nil ->
  #       conn
  #       |> put_flash(:error, gettext("Permission not found."))
  #       |> redirect(to: Routes.permission_path(conn, :index))
  #   end
  # end

  def new(conn, _params) do
    roles = Entities.select_roles()
    contexts = Entities.select_contexts()
    operations = Entities.select_operations()
    domains = Entities.select_domains()

    changeset = Permission.changeset(
      preload_associations(%Permission{})
    )
    render(conn, "new.html",
      changeset: changeset,
      roles: roles, contexts: contexts,
      operations: operations, domains: domains
    )
  end

  def create(conn, %{"permission" => permission_params}) do
    with {:ok, _permission} <- Entities.create_permission(permission_params) do
      conn
        |> put_flash(:info, gettext("Permission created successfully."))
        |> redirect(to: Routes.permission_path(conn, :index))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        data = preload_associations(changeset.data)
        roles = Entities.select_roles()
        contexts = Entities.select_contexts()
        operations = Entities.select_operations()
        domains = Entities.select_domains()

        render(conn, "new.html",
          changeset: %{changeset | data: data},
          roles: roles, contexts: contexts,
          operations: operations, domains: domains
        )
    end
  end

  def edit(conn, %{"id" => id}) do
    roles = Entities.select_roles()
    contexts = Entities.select_contexts()
    operations = Entities.select_operations()
    domains = Entities.select_domains()

    permission = id |> Entities.get_permission!() |> preload_associations()
    changeset = Entities.change_permission(permission)
    render(conn, "edit.html",
      permission: permission, changeset: changeset,
      roles: roles, contexts: contexts,
      operations: operations, domains: domains
    )
  end

  def update(conn, %{"id" => id, "permission" => permission_params}) do
    permission = id |> Entities.get_permission!() |> preload_associations()

    case Entities.update_permission(permission, permission_params) do
      {:ok, _permission} ->
        conn
        |> put_flash(:info, gettext("Permission updated successfully."))
        |> redirect(to: Routes.permission_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        data = preload_associations(changeset.data)
        roles = Entities.select_roles()
        contexts = Entities.select_contexts()
        operations = Entities.select_operations()
        domains = Entities.select_domains()

        render(conn, "edit.html",
          permission: permission,
          changeset: %{changeset | data: data},
          roles: roles, contexts: contexts,
          operations: operations, domains: domains
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    permission = Entities.get_permission!(id)
    {:ok, _permission} = Entities.delete_permission(permission)

    conn
    |> put_flash(:info, gettext("Permission deleted successfully."))
    |> redirect(to: Routes.permission_path(conn, :index))
  end

  # Private

  defp preload_associations(any), do: Rbax.Repo.preload(any, [:role, :context, :operation, :domain])
end
