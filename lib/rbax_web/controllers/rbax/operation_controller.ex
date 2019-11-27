defmodule RbaxWeb.Rbax.OperationController do
  use RbaxWeb, :controller

  alias Rbax.Entities
  alias Entities.Operation

  plug :authenticate

  def index(conn, _params) do
    operations =  Entities.list_operations()
    |> preload_rights()
    render(conn, "index.html", operations: operations)
  end

  # def show(conn, %{"id" => id}) do
  #   with %Operation{} = operation <- Entities.get_operation!(id) do
  #     render(conn, "show.html", operation: preload_rights(operation))
  #   else
  #     nil ->
  #       conn
  #       |> put_flash(:error, gettext("Operation not found."))
  #       |> redirect(to: Routes.operation_path(conn, :index))
  #   end
  # end

  def new(conn, _params) do
    rights = Entities.list_rights()
    changeset = Operation.changeset(
      preload_rights(%Operation{})
    )
    render(conn, "new.html", changeset: changeset, rights: rights)
  end

  def create(conn, %{"operation" => operation_params}) do
    with {:ok, _operation} <- Entities.create_operation(operation_params) do
      conn
        |> put_flash(:info, gettext("Operation created successfully."))
        |> redirect(to: Routes.operation_path(conn, :index))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        data = preload_rights(changeset.data)
        rights = Entities.list_rights()
        render(conn, "new.html", changeset: %{changeset | data: data}, rights: rights)
    end
  end

  def edit(conn, %{"id" => id}) do
    operation = id |> Entities.get_operation!() |> preload_rights

    changeset = Entities.change_operation(operation)
    rights = Entities.list_rights()
    render(conn, "edit.html", operation: operation, changeset: changeset, rights: rights)
  end

  def update(conn, %{"id" => id, "operation" => operation_params}) do
    operation = id |> Entities.get_operation!() |> preload_rights

    case Entities.update_operation(operation, operation_params) do
      {:ok, _operation} ->
        conn
        |> put_flash(:info, gettext("Operation updated successfully."))
        |> redirect(to: Routes.operation_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        data = preload_rights(changeset.data)
        rights = Entities.list_rights()
        render(conn, "edit.html",
          operation: operation,
          changeset: %{changeset | data: data},
          rights: rights
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    operation = Entities.get_operation!(id)
    {:ok, _operation} = Entities.delete_operation(operation)

    conn
    |> put_flash(:info, gettext("Operation deleted successfully."))
    |> redirect(to: Routes.operation_path(conn, :index))
  end

    # Private

    defp preload_rights(any), do: Rbax.Repo.preload(any, :rights)
end
