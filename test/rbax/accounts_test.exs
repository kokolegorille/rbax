defmodule Rbax.AccountsTest do
  use Rbax.DataCase

  # alias Rbax.Entities
  # alias Entities.Subject

  # @password "password"
  # @valid_subject_attrs %{name: "koko", password: @password}
  # @invalid_subject_attrs %{name: "koko", password: nil}

  # describe "Accounts" do
  #   def subject_fixture(attrs \\ %{}) do
  #     {:ok, subject} =
  #       attrs
  #       |> Enum.into(@valid_subject_attrs)
  #       |> Entities.create_subject()
  #     subject
  #   end

  #   test "can authenticate subject" do
  #     subject = subject_fixture()
  #     subject_by_id = Entities.get_subject!(subject.id)
  #     assert subject.name == subject_by_id.name
  #     assert Entities.authenticate(subject.name, subject.password)
  #   end
  # end
end
