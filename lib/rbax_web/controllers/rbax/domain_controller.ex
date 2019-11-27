defmodule RbaxWeb.Rbax.DomainController do
  use RbaxWeb, :controller

  alias Rbax.Entities
  alias Entities.Domain

  plug :authenticate

  def index(conn, _params) do
    domains =  Entities.list_domains(order: :asc)
    |> preload_objects()
    render(conn, "index.html", domains: domains)
  end

  def show(conn, %{"id" => id}) do
    with %Domain{} = domain <- Entities.get_domain!(id) do
      render(conn, "show.html", domain: preload_objects(domain))
    else
      nil ->
        conn
        |> put_flash(:error, gettext("Domain not found."))
        |> redirect(to: Routes.domain_path(conn, :index))
    end
  end

  def new(conn, _params) do
    objects = Entities.list_objects()
    changeset = Domain.changeset(
      preload_objects(%Domain{})
    )
    render(conn, "new.html", changeset: changeset, objects: objects)
  end

  def create(conn, %{"domain" => domain_params}) do
    with {:ok, domain} <- Entities.create_domain(domain_params) do
      conn
        |> put_flash(:info, gettext("Domain created successfully."))
        |> redirect(to: Routes.domain_path(conn, :show, domain))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        data = preload_objects(changeset.data)
        objects = Entities.list_objects()
        render(conn, "new.html", changeset: %{changeset | data: data}, objects: objects)
    end
  end

  def edit(conn, %{"id" => id}) do
    domain = id |> Entities.get_domain!() |> preload_objects()

    changeset = Entities.change_domain(domain)
    objects = Entities.list_objects()
    render(conn, "edit.html", domain: domain, changeset: changeset, objects: objects)
  end

  def update(conn, %{"id" => id, "domain" => domain_params}) do
    domain = id |> Entities.get_domain!() |> preload_objects()

    case Entities.update_domain(domain, domain_params) do
      {:ok, domain} ->
        conn
        |> put_flash(:info, gettext("Domain updated successfully."))
        |> redirect(to: Routes.domain_path(conn, :show, domain))

      {:error, %Ecto.Changeset{} = changeset} ->
        data = preload_objects(changeset.data)
        objects = Entities.list_objects()
        render(conn, "edit.html",
          domain: domain,
          changeset: %{changeset | data: data},
          objects: objects
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    domain = Entities.get_domain!(id)
    {:ok, _domain} = Entities.delete_domain(domain)

    conn
    |> put_flash(:info, gettext("Domain deleted successfully."))
    |> redirect(to: Routes.domain_path(conn, :index))
  end

  # Private

  defp preload_objects(any), do: Rbax.Repo.preload(any, :objects)
end
