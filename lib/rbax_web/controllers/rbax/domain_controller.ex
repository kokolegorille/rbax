defmodule RbaxWeb.Rbax.DomainController do
  use RbaxWeb, :controller

  alias Rbax.Entities
  alias Entities.Domain

  plug :authenticate

  def index(conn, _params) do
    domains =  Entities.list_domains(order: :asc)
    |> preload_resources()
    render(conn, "index.html", domains: domains)
  end

  def show(conn, %{"id" => id}) do
    with %Domain{} = domain <- Entities.get_domain!(id) do
      render(conn, "show.html", domain: preload_resources(domain))
    else
      nil ->
        conn
        |> put_flash(:error, gettext("Domain not found."))
        |> redirect(to: Routes.domain_path(conn, :index))
    end
  end

  def new(conn, _params) do
    resources = Entities.list_resources()
    changeset = Domain.changeset(
      preload_resources(%Domain{})
    )
    render(conn, "new.html", changeset: changeset, resources: resources)
  end

  def create(conn, %{"domain" => domain_params}) do
    with {:ok, domain} <- Entities.create_domain(domain_params) do
      conn
        |> put_flash(:info, gettext("Domain created successfully."))
        |> redirect(to: Routes.domain_path(conn, :show, domain))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        data = preload_resources(changeset.data)
        resources = Entities.list_resources()
        render(conn, "new.html", changeset: %{changeset | data: data}, resources: resources)
    end
  end

  def edit(conn, %{"id" => id}) do
    domain = id |> Entities.get_domain!() |> preload_resources()

    changeset = Entities.change_domain(domain)
    resources = Entities.list_resources()
    render(conn, "edit.html", domain: domain, changeset: changeset, resources: resources)
  end

  def update(conn, %{"id" => id, "domain" => domain_params}) do
    domain = id |> Entities.get_domain!() |> preload_resources()

    case Entities.update_domain(domain, domain_params) do
      {:ok, domain} ->
        conn
        |> put_flash(:info, gettext("Domain updated successfully."))
        |> redirect(to: Routes.domain_path(conn, :show, domain))

      {:error, %Ecto.Changeset{} = changeset} ->
        data = preload_resources(changeset.data)
        resources = Entities.list_resources()
        render(conn, "edit.html",
          domain: domain,
          changeset: %{changeset | data: data},
          resources: resources
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

  defp preload_resources(any), do: Rbax.Repo.preload(any, :resources)
end
