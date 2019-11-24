defmodule RbaxWeb.Rbax.SubjectController do
  use RbaxWeb, :controller

  alias Rbax.Entities
  alias Entities.Subject

  def index(conn, _params) do
    subjects =  Entities.list_subjects()
    render(conn, "index.html", subjects: subjects)
  end

  def show(conn, %{"id" => id}) do
    with %Subject{} = subject <- Entities.get_subject!(id) do
      render(conn, "show.html", subject: preload_roles(subject))
    else
      nil ->
        conn
        |> put_flash(:error, gettext("Subject not found."))
        |> redirect(to: Routes.subject_path(conn, :index))
    end
  end

  def new(conn, _params) do
    # changeset = Subject.changeset(%Subject{})
    # render(conn, "new.html", changeset: changeset)

    roles = Entities.list_roles()
    changeset = Subject.changeset(
      preload_roles(%Subject{})
    )
    render(conn, "new.html", changeset: changeset, roles: roles)
  end

  def create(conn, %{"subject" => subject_params}) do
    # with {:ok, subject} <- Entities.create_subject(subject_params) do
    #   conn
    #     |> put_flash(:info, gettext("Subject created successfully."))
    #     |> redirect(to: Routes.subject_path(conn, :show, subject))
    # else
    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, "new.html", changeset: changeset)
    # end

    with {:ok, subject} <- Entities.create_subject(subject_params) do
      conn
        |> put_flash(:info, gettext("Subject created successfully."))
        |> redirect(to: Routes.subject_path(conn, :show, subject))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        data = preload_roles(changeset.data)
        roles = Entities.list_roles()
        render(conn, "new.html", changeset: %{changeset | data: data}, roles: roles)
    end
  end

  def edit(conn, %{"id" => id}) do
    # subject = Entities.get_subject!(id)
    # changeset = Entities.change_subject(subject)
    # render(conn, "edit.html", subject: subject, changeset: changeset)

    subject =
      id
        |> Entities.get_subject!()
        |> preload_roles()

    changeset = Entities.change_subject(subject)
    roles = Entities.list_roles()
    render(conn, "edit.html", subject: subject, changeset: changeset, roles: roles)
  end

  def update(conn, %{"id" => id, "subject" => subject_params}) do
    # subject = Entities.get_subject!(id)

    # case Entities.update_subject(subject, subject_params) do
    #   {:ok, subject} ->
    #     conn
    #     |> put_flash(:info, gettext("Subject updated successfully."))
    #     |> redirect(to: Routes.subject_path(conn, :show, subject))

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, "edit.html", subject: subject, changeset: changeset)
    # end

    subject =
      id
        |> Entities.get_subject!()
        |> preload_roles()

    case Entities.update_subject(subject, subject_params) do
      {:ok, subject} ->
        conn
        |> put_flash(:info, gettext("Subject updated successfully."))
        |> redirect(to: Routes.subject_path(conn, :show, subject))

      {:error, %Ecto.Changeset{} = changeset} ->
        data = preload_roles(changeset.data)
        roles = Entities.list_roles()
        render(conn, "edit.html",
          subject: subject,
          changeset: %{changeset | data: data},
          roles: roles
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    subject = Entities.get_subject!(id)
    {:ok, _subject} = Entities.delete_subject(subject)

    conn
    |> put_flash(:info, gettext("Subject deleted successfully."))
    |> redirect(to: Routes.subject_path(conn, :index))
  end

  # Private

  defp preload_roles(any), do: Rbax.Repo.preload(any, :roles)
end
