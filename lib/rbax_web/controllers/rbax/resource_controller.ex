defmodule RbaxWeb.Rbax.ResourceController do
  use RbaxWeb, :controller

  alias Rbax.Entities
  alias Entities.Resource

  plug :authenticate

  def index(conn, _params) do
    resources =  Entities.list_resources(order: :asc)
    |> preload_domains()
    render(conn, "index.html", resources: resources)
  end

  def show(conn, %{"id" => id}) do
    with %Resource{} = resource <- Entities.get_resource!(id) do
      render(conn, "show.html", resource: preload_domains(resource))
    else
      nil ->
        conn
        |> put_flash(:error, gettext("Resource not found."))
        |> redirect(to: Routes.resource_path(conn, :index))
    end
  end

  def new(conn, _params) do
    domains = Entities.list_domains()
    changeset = Resource.changeset(
      preload_domains(%Resource{})
    )
    render(conn, "new.html", changeset: changeset, domains: domains)
  end

  def create(conn, %{"resource" => resource_params}) do
    with {:ok, resource} <- Entities.create_resource(resource_params) do
      conn
        |> put_flash(:info, gettext("Resource created successfully."))
        |> redirect(to: Routes.resource_path(conn, :show, resource))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        data = preload_domains(changeset.data)
        domains = Entities.list_domains()
        render(conn, "new.html", changeset: %{changeset | data: data}, domains: domains)
    end
  end

  def edit(conn, %{"id" => id}) do
    resource = id |> Entities.get_resource!() |> preload_domains()

    changeset = Entities.change_resource(resource)
    domains = Entities.list_domains()
    render(conn, "edit.html", resource: resource, changeset: changeset, domains: domains)
  end

  def update(conn, %{"id" => id, "resource" => resource_params}) do
    resource = id |> Entities.get_resource!() |> preload_domains()

    case Entities.update_resource(resource, resource_params) do
      {:ok, resource} ->
        conn
        |> put_flash(:info, gettext("Resource updated successfully."))
        |> redirect(to: Routes.resource_path(conn, :show, resource))

      {:error, %Ecto.Changeset{} = changeset} ->
        data = preload_domains(changeset.data)
        domains = Entities.list_domains()
        render(conn, "edit.html",
          resource: resource,
          changeset: %{changeset | data: data},
          domains: domains
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    resource = Entities.get_resource!(id)
    {:ok, _resource} = Entities.delete_resource(resource)

    conn
    |> put_flash(:info, gettext("Resource deleted successfully."))
    |> redirect(to: Routes.resource_path(conn, :index))
  end

  # Private

  defp preload_domains(any), do: Rbax.Repo.preload(any, :domains)
end
