defmodule Practice.SchemaModule do
  import Ecto.Query
  alias MusicDB.{Repo, Track, Artist}

  def data_schemaless() do
    artist = "1"
    q = from "artists", where: [id: type(^artist, :integer)],
    select: [:name]

    Repo.all q

    q = from a in "artists",
    join: al in "albums",
    on: a.id == al.artist_id,
    group_by: a.name,
    select: %{artist: a.name, number_of_albums: count(al.id)}

    Repo.all q
  end

  def query_with_schema() do
    track_id = "1"
    q = from Track, where: [id: ^track_id], select: [:title]
    Repo.all q

    q = from t in Track, where: t.id == ^track_id
    Repo.all q
  end

  def inserting() do
    Repo.insert(%Artist{name: "Malo"})
    Repo.insert_all(Artist, [[name: "Luis miguel"]])
  end

  def deleting() do
    track = Repo.get_by(Track, title: "The Moontrane")
    Repo.delete(Track, title: "The Moontrane")
    #Repo.delete_all("tracks")

  end
end
#IO.inspect(Practice.SchemaModule.data_schemaless())
#IO.inspect(Practice.SchemaModule.query_with_schema())
#IO.inspect(Practice.SchemaModule.inserting())
IO.inspect(Practice.SchemaModule.deleting())
