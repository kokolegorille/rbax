defmodule RbaxWeb.Resolvers.AccountsResolver do
  alias Rbax.{Accounts, Entities}
  alias RbaxWeb.TokenHelpers
  alias RbaxWeb.Schema.ChangesetErrors

  def signin(_, %{name: name, password: password}, _) do
    case Accounts.authenticate(name, password) do
      {:error, reason} ->
        {:error, reason}

      {:ok, subject} ->
        token = TokenHelpers.sign(subject)
        {:ok, %{subject: subject, token: token}}
    end
  end

  def signup(_, args, _) do
    case Entities.create_subject(args) do
      {:error, changeset} ->
        {
          :error,
          message: "Could not create account",
          details: ChangesetErrors.error_details(changeset)
        }

      {:ok, subject} ->
        token = TokenHelpers.sign(subject)
        {:ok, %{subject: subject, token: token}}
    end
  end

  def me(_, _, %{context: %{current_user: subject}}) do
    {:ok, subject}
  end

  def me(_, _, _) do
    {:ok, nil}
  end
end
