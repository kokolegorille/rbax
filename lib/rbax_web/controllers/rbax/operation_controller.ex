defmodule RbaxWeb.Rbax.OperationController do
  use RbaxWeb, :controller

  alias Rbax.Entities
  alias Entities.Operation

  def index(conn, _params) do
    operations =  Entities.list_operations()
    render(conn, "index.html", operations: operations)
  end

  def show(conn, %{"id" => id}) do
    with %Operation{} = operation <- Entities.get_operation!(id) do
      render(conn, "show.html", operation: operation)
    else
      nil ->
        conn
        |> put_flash(:error, gettext("Operation not found."))
        |> redirect(to: Routes.operation_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Operation.changeset(%Operation{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"operation" => operation_params}) do
    with {:ok, operation} <- Entities.create_operation(operation_params) do
      conn
        |> put_flash(:info, gettext("Operation created successfully."))
        |> redirect(to: Routes.operation_path(conn, :show, operation))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    operation = Entities.get_operation!(id)
    changeset = Entities.change_operation(operation)
    render(conn, "edit.html", operation: operation, changeset: changeset)
  end

  def update(conn, %{"id" => id, "operation" => operation_params}) do
    operation = Entities.get_operation!(id)

    case Entities.update_operation(operation, operation_params) do
      {:ok, operation} ->
        conn
        |> put_flash(:info, gettext("Operation updated successfully."))
        |> redirect(to: Routes.operation_path(conn, :show, operation))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", operation: operation, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    operation = Entities.get_operation!(id)
    {:ok, _operation} = Entities.delete_operation(operation)

    conn
    |> put_flash(:info, gettext("Operation deleted successfully."))
    |> redirect(to: Routes.operation_path(conn, :index))
  end
end
