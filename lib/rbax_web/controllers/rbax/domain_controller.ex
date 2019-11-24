defmodule RbaxWeb.Rbax.DomainController do
  use RbaxWeb, :controller

  alias Rbax.Entities
  alias Entities.Domain

  def index(conn, _params) do
    domains =  Entities.list_domains()
    render(conn, "index.html", domains: domains)
  end

  def show(conn, %{"id" => id}) do
    with %Domain{} = domain <- Entities.get_domain!(id) do
      render(conn, "show.html", domain: domain)
    else
      nil ->
        conn
        |> put_flash(:error, gettext("Domain not found."))
        |> redirect(to: Routes.domain_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Domain.changeset(%Domain{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"domain" => domain_params}) do
    with {:ok, domain} <- Entities.create_domain(domain_params) do
      conn
        |> put_flash(:info, gettext("Domain created successfully."))
        |> redirect(to: Routes.domain_path(conn, :show, domain))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    domain = Entities.get_domain!(id)
    changeset = Entities.change_domain(domain)
    render(conn, "edit.html", domain: domain, changeset: changeset)
  end

  def update(conn, %{"id" => id, "domain" => domain_params}) do
    domain = Entities.get_domain!(id)

    case Entities.update_domain(domain, domain_params) do
      {:ok, domain} ->
        conn
        |> put_flash(:info, gettext("Domain updated successfully."))
        |> redirect(to: Routes.domain_path(conn, :show, domain))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", domain: domain, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    domain = Entities.get_domain!(id)
    {:ok, _domain} = Entities.delete_domain(domain)

    conn
    |> put_flash(:info, gettext("Domain deleted successfully."))
    |> redirect(to: Routes.domain_path(conn, :index))
  end
end
