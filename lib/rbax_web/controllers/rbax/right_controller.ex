defmodule RbaxWeb.Rbax.RightController do
  use RbaxWeb, :controller

  alias Rbax.Entities
  alias Entities.Right

  def index(conn, _params) do
    rights =  Entities.list_rights()
    |> preload_operations()
    render(conn, "index.html", rights: rights)
  end

  # def show(conn, %{"id" => id}) do
  #   with %Right{} = right <- Entities.get_right!(id) do
  #     render(conn, "show.html", right: preload_operations(right))
  #   else
  #     nil ->
  #       conn
  #       |> put_flash(:error, gettext("Right not found."))
  #       |> redirect(to: Routes.right_path(conn, :index))
  #   end
  # end

  def new(conn, _params) do
    operations = Entities.list_operations()
    changeset = Right.changeset(
      preload_operations(%Right{})
    )
    render(conn, "new.html", changeset: changeset, operations: operations)
  end

  def create(conn, %{"right" => right_params}) do
    with {:ok, _right} <- Entities.create_right(right_params) do
      conn
        |> put_flash(:info, gettext("Right created successfully."))
        |> redirect(to: Routes.right_path(conn, :index))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        data = preload_operations(changeset.data)
        operations = Entities.list_operations()
        render(conn, "new.html", changeset: %{changeset | data: data}, operations: operations)
    end
  end

  def edit(conn, %{"id" => id}) do
    right = id |> Entities.get_right!() |> preload_operations()

    changeset = Entities.change_right(right)
    operations = Entities.list_operations()
    render(conn, "edit.html", right: right, changeset: changeset, operations: operations)
  end

  def update(conn, %{"id" => id, "right" => right_params}) do
    right = id |> Entities.get_right!() |> preload_operations()

    case Entities.update_right(right, right_params) do
      {:ok, _right} ->
        conn
        |> put_flash(:info, gettext("Right updated successfully."))
        |> redirect(to: Routes.right_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        data = preload_operations(changeset.data)
        operations = Entities.list_operations()
        render(conn, "edit.html",
          right: right,
          changeset: %{changeset | data: data},
          operations: operations
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    right = Entities.get_right!(id)
    {:ok, _right} = Entities.delete_right(right)

    conn
    |> put_flash(:info, gettext("Right deleted successfully."))
    |> redirect(to: Routes.right_path(conn, :index))
  end

  # Private

  defp preload_operations(any), do: Rbax.Repo.preload(any, :operations)
end
