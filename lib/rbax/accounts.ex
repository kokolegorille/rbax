defmodule Rbax.Accounts do
  alias Rbax.{Entities, Repo}
  alias Entities.Subject

  def get_subject(id), do: Repo.get(Subject, id)

  def authenticate(name, password),
    do: authenticate(%{"name" => name, "password" => password})

  def authenticate(%{name: name, password: password}),
    do: authenticate(%{"name" => name, "password" => password})

  def authenticate(%{"name" => name, "password" => password}) do
    with %Subject{} = subject <- Entities.get_subject_by_name(name),
        true <- check_password(subject, password) do
      {:ok, subject}
    else
      _ -> {:error, :unauthorized}
    end
  end

  def authenticate(_), do: {:error, :unauthorized}

  defp check_password(subject, password) do
    Pbkdf2.verify_pass(password, subject.password_hash)
  end
end
