defmodule RbaxWeb.Rbax.RightController do
  use RbaxWeb, :controller

  alias Rbax.Entities
  alias Entities.Right

  def index(conn, _params) do
    rights =  Entities.list_rights()
    render(conn, "index.html", rights: rights)
  end

  def show(conn, %{"id" => id}) do
    with %Right{} = right <- Entities.get_right!(id) do
      render(conn, "show.html", right: right)
    else
      nil ->
        conn
        |> put_flash(:error, gettext("Right not found."))
        |> redirect(to: Routes.right_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Right.changeset(%Right{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"right" => right_params}) do
    with {:ok, right} <- Entities.create_right(right_params) do
      conn
        |> put_flash(:info, gettext("Right created successfully."))
        |> redirect(to: Routes.right_path(conn, :show, right))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    right = Entities.get_right!(id)
    changeset = Entities.change_right(right)
    render(conn, "edit.html", right: right, changeset: changeset)
  end

  def update(conn, %{"id" => id, "right" => right_params}) do
    right = Entities.get_right!(id)

    case Entities.update_right(right, right_params) do
      {:ok, right} ->
        conn
        |> put_flash(:info, gettext("Right updated successfully."))
        |> redirect(to: Routes.right_path(conn, :show, right))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", right: right, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    right = Entities.get_right!(id)
    {:ok, _right} = Entities.delete_right(right)

    conn
    |> put_flash(:info, gettext("Right deleted successfully."))
    |> redirect(to: Routes.right_path(conn, :index))
  end
end
