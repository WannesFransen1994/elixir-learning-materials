defmodule I18nTranslationsTest do
  use ExUnit.Case
  doctest I18nTranslations

  test "greets the world" do
    assert I18nTranslations.hello() == :world
  end
end
