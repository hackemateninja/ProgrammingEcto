defmodule Practice.SchemaModule do
  import Ecto.Query
  alias MusicDB.{Repo, Track, Artist, Album}

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
    #track = Repo.get_by(Track, title: "The Moontrane")
    #Repo.delete(track)
    #Repo.delete_all("tracks")
    q = from MusicDB.Artist
    Repo.all q
  end

  def getting_associated() do
    albums =
      Album
      |>Repo.all
      |>Repo.preload(:tracks)

    albums

    q = from a in Album,
      join: t in assoc(a, :tracks),
      where: t.title == "Freddie Freeloader",
      preload: [tracks: t]

    Repo.all q
  end

  def seed_with_schemas() do
    Repo.insert(
      %Artist{
        name: "Vilma palma",
        tracks: [
          %Track{
            title: "Borracho hasta el amanecer"
          }
        ]
      }
    )
  end
end
#IO.inspect(Practice.SchemaModule.data_schemaless())
#IO.inspect(Practice.SchemaModule.query_with_schema())
#IO.inspect(Practice.SchemaModule.inserting())
#IO.inspect(Practice.SchemaModule.deleting())
#IO.inspect(Practice.SchemaModule.getting_associated)
IO.inspect(Practice.SchemaModule.seed_with_schemas())
