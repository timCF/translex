defmodule TranslexTest do
  use ExUnit.Case

  test "it works" do
    assert "SHkola_Anime_Stjob_School999_Anime_Fun" == Translex.encode("Школа Аниме Стёб School999 Anime Fun")
    assert "SHkola_Anime_Stjob_School999_Anime_Fun" == Translex.encode("Школа Аниме Стёб School999 Anime Fun", :ru)
  end
end
