defmodule RbaxWeb.Plugs.Auth do
  @moduledoc false
  import Plug.Conn
  import Phoenix.Controller
  alias RbaxWeb.Router.Helpers, as: Routes
  alias Rbax.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    subject_id = get_session(conn, :subject_id)
    subject = subject_id && Accounts.get_subject(subject_id)
    assign(conn, :current_user, subject)
  end

  def login_by_name_and_password(conn, name, password) do
    case Accounts.authenticate(name, password) do
      {:ok, subject} -> {:ok, login(conn, subject)}
      {:error, :unauthorized} -> {:error, :unauthorized, conn}
    end
  end

  def login(conn, subject) do
    conn
    |> assign(:current_user, subject)
    |> put_session(:subject_id, subject.id)
    |> configure_session(renew: true)
  end

  def logout(conn), do: configure_session(conn, drop: true)

  def authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_session(:redirect_url, conn.request_path)
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end
end
