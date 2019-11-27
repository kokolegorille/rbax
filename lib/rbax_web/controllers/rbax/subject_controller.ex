defmodule RbaxWeb.Rbax.SubjectController do
  use RbaxWeb, :controller

  alias Rbax.Entities
  alias Entities.Subject

  # Use plug action to check rbax
  # def action(conn, _) do
  #   # Preload object to test
  #   # TODO : Check for nested resources

  #   object_or_nil = load_object(conn, conn.params)

  #   IO.inspect object_or_nil, label: "OBJECT"

  #   can = Engine.can?(
  #     conn.assigns.current_user,
  #     controller_module(conn),
  #     action_name(conn),
  #     object_or_nil
  #   )

  #   IO.inspect can, label: "CAN?"

  #   apply(__MODULE__, action_name(conn), [conn, conn.params])
  # end

  def action(conn, _opts) do
    object_or_nil = case conn.params do
      %{"id" => id} -> Entities.get_subject!(String.to_integer(id))
      _ -> nil
    end

    IO.inspect object_or_nil, label: "OBJECT"

    if not can?(conn, object_or_nil) do
      conn
      |> put_flash(:error, "Your security level disallow access to that page.")
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    else
      apply(__MODULE__, action_name(conn), [conn, conn.params])
    end
  end

  def index(conn, _params) do
    subjects =  Entities.list_subjects()
    |> preload_roles()
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

  # def show(conn, %{"id" => id}) do
  #   with %Subject{} = subject <- Entities.get_subject!(id),
  #     true <- can?(conn, subject)
  #   do
  #     render(conn, "show.html", subject: preload_roles(subject))
  #   else
  #     nil ->
  #       conn
  #       |> put_flash(:error, gettext("Subject not found."))
  #       |> redirect(to: Routes.subject_path(conn, :index))
  #     false ->
  #       conn
  #       |> put_flash(:error, "Your security level disallow access to that page.")
  #       |> redirect(to: Routes.session_path(conn, :new))
  #   end
  # end

  # def show(conn, params) do
  #   subject = load_object(conn, params)
  #   render(conn, "show.html", subject: preload_roles(subject))
  # end

  def new(conn, _params) do
    roles = Entities.list_roles()
    changeset = Subject.changeset(
      preload_roles(%Subject{})
    )
    render(conn, "new.html", changeset: changeset, roles: roles)
  end

  def create(conn, %{"subject" => subject_params}) do
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
    subject = id |> Entities.get_subject!() |> preload_roles()

    changeset = Entities.change_subject(subject)
    roles = Entities.list_roles()
    render(conn, "edit.html", subject: subject, changeset: changeset, roles: roles)
  end

  # def edit(conn, params) do
  #   subject = load_object(conn, params) |> preload_roles()

  #   changeset = Entities.change_subject(subject)
  #   roles = Entities.list_roles()
  #   render(conn, "edit.html", subject: subject, changeset: changeset, roles: roles)
  # end

  def update(conn, %{"id" => id, "subject" => subject_params}) do
    subject = id |> Entities.get_subject!() |> preload_roles()

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

  # def update(conn, %{"id" => id, "subject" => subject_params}) do
  #   subject = load_object(conn, %{"id" => id}) |> preload_roles()

  #   case Entities.update_subject(subject, subject_params) do
  #     {:ok, subject} ->
  #       conn
  #       |> put_flash(:info, gettext("Subject updated successfully."))
  #       |> redirect(to: Routes.subject_path(conn, :show, subject))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       data = preload_roles(changeset.data)
  #       roles = Entities.list_roles()
  #       render(conn, "edit.html",
  #         subject: subject,
  #         changeset: %{changeset | data: data},
  #         roles: roles
  #       )
  #   end
  # end

  def delete(conn, %{"id" => id}) do
    subject = Entities.get_subject!(id)
    {:ok, _subject} = Entities.delete_subject(subject)

    conn
    |> put_flash(:info, gettext("Subject deleted successfully."))
    |> redirect(to: Routes.subject_path(conn, :index))
  end

  # def delete(conn, %{"id" => id}) do
  #   subject = load_object(conn, %{"id" => id})
  #   {:ok, _subject} = Entities.delete_subject(subject)

  #   conn
  #   |> put_flash(:info, gettext("Subject deleted successfully."))
  #   |> redirect(to: Routes.subject_path(conn, :index))
  # end

  # Private

  # defp load_object(conn, %{"id" => id}) do
  #   try do
  #     Entities.get_subject!(id)
  #   rescue
  #     _ ->
  #       conn
  #       |> put_flash(:error, gettext("Not found."))
  #       |> redirect(to: Routes.subject_path(conn, :index))
  #       |> halt()
  #   end
  # end
  # defp load_object(_conn, _), do: nil

  defp preload_roles(any), do: Rbax.Repo.preload(any, :roles)
end
