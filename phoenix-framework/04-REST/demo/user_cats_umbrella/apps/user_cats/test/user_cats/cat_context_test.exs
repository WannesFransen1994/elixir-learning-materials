defmodule UserCats.CatContextTest do
  use UserCats.DataCase

  alias UserCats.CatContext

  describe "cats" do
    alias UserCats.CatContext.Cat

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def cat_fixture(attrs \\ %{}) do
      {:ok, cat} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CatContext.create_cat()

      cat
    end

    test "list_cats/0 returns all cats" do
      cat = cat_fixture()
      assert CatContext.list_cats() == [cat]
    end

    test "get_cat!/1 returns the cat with given id" do
      cat = cat_fixture()
      assert CatContext.get_cat!(cat.id) == cat
    end

    test "create_cat/1 with valid data creates a cat" do
      assert {:ok, %Cat{} = cat} = CatContext.create_cat(@valid_attrs)
      assert cat.name == "some name"
    end

    test "create_cat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CatContext.create_cat(@invalid_attrs)
    end

    test "update_cat/2 with valid data updates the cat" do
      cat = cat_fixture()
      assert {:ok, %Cat{} = cat} = CatContext.update_cat(cat, @update_attrs)
      assert cat.name == "some updated name"
    end

    test "update_cat/2 with invalid data returns error changeset" do
      cat = cat_fixture()
      assert {:error, %Ecto.Changeset{}} = CatContext.update_cat(cat, @invalid_attrs)
      assert cat == CatContext.get_cat!(cat.id)
    end

    test "delete_cat/1 deletes the cat" do
      cat = cat_fixture()
      assert {:ok, %Cat{}} = CatContext.delete_cat(cat)
      assert_raise Ecto.NoResultsError, fn -> CatContext.get_cat!(cat.id) end
    end

    test "change_cat/1 returns a cat changeset" do
      cat = cat_fixture()
      assert %Ecto.Changeset{} = CatContext.change_cat(cat)
    end
  end
end
