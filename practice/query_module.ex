
#alias MusicDB.{Artist, Album, Track, Genre, Log, AlbumWithEmbeds, ArtistEmbed, TrackEmbed}
#alias Ecto.Multi

defmodule Practice.QueryModule do
  alias MusicDB.{Repo}
  import Ecto.Query

  #this fetch the number or record on a table
  def count_records(table_name) do
    Repo.aggregate(table_name, :count, :id)
  end
end

IO.inspect(Practice.QueryModule.count_records("tracks"))
