defmodule Rbax.EntitiesTest do
  use Rbax.DataCase

  alias Rbax.Entities
  alias Entities.Subject

  @password "password"
  @valid_subject_attrs %{name: "koko", password: @password}
  @invalid_subject_attrs %{name: "koko", password: nil}

  describe "Subjects" do
    def subject_fixture(attrs \\ %{}) do
      {:ok, subject} =
        attrs
        |> Enum.into(@valid_subject_attrs)
        |> Entities.create_subject()
      subject
    end

    test "changeset with valid attributes" do
      changeset = Entities.change_subject(%Subject{}, @valid_subject_attrs)
      assert changeset.valid?
    end

    test "changeset without password" do
      changeset = Entities.registration_change_subject(%Subject{}, @invalid_subject_attrs)
      refute changeset.valid?
    end

    test "list_subjects/0 returns all subjects" do
      subject = subject_fixture()
      id = subject.id
      assert [%Subject{id: ^id}] = Entities.list_subjects()
    end

    test "get_subject!/1 returns the subject with given id" do
      subject = subject_fixture()
      subject_by_id = Entities.get_subject!(subject.id)
      assert subject.name == subject_by_id.name
    end
  end
end
