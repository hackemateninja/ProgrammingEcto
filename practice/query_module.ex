defmodule Practice.QueryModule do
  alias MusicDB.{Repo}
  import Ecto.Query

  def query_demo() do
    #query = from t in "tracks",
    #join: a in "albums", on: t.album_id == a.id,
    #where: t.duration > 900,
    #select: [t.id, t.title, a.title]

    query = from "artists", prefix: "public", select: [:name]
    Repo.all(query)

    band = "Alux Nahual"
    query = from "artists", where: [name: ^band], select: [:id, :name]
    Repo.to_sql(:all, query)
    Repo.all(query)
  end

  def dynamic_types(id) do
    q = from "artists", where: [id: type(^id, :integer)], select: [:id, :name]
    Repo.all(q)
  end

  def query_binding(name) do
    q = from a in "artists", where: a.name == ^name, select: [:id, :name]
    Repo.all(q)

    q = from a in "artists", where: like(a.name, "Tambor"), select: [:id, :name]
    Repo.all(q)

    q = from a in "artists", where: is_nil(a.name), select: [:id, :name]
    Repo.all(q)

    q = from a in "artists", where: not is_nil(a.name), select: [:id, :name]
    Repo.all(q)

    q = from a in "artists", where: a.inserted_at < ago(1, "year"), select: [:id, :name]
    Repo.all(q)

    q = from a in "artists", where: fragment("lower(?)", a.name) == "alux nahual", select: [:id, :name]
    Repo.all(q)
  end

  def combine() do
    tracks = from t in "tracks", select: t.title
    union = from a in "albums", select: a.title, union: ^tracks
    Repo.all(union)

    intersect = from a in "albums", select: a.title, intersect: ^tracks
    Repo.all(intersect)

    except = from a in "albums", select: a.title, except: ^tracks
    Repo.all(except)
  end

  def ordering() do
    q = from a in "artists", select: a.name, order_by: a.name
    Repo.all(q)

    q = from a in "artists", select: a.name, order_by: [desc: a.name]
    Repo.all(q)

    # when using atoms in select, we will get a map otherway will be a list
    q = from t in "tracks", select: [:album_id, :title, :index], order_by: [t.album_id, t.index]
    Repo.all(q)

    q = from t in "tracks", select: [:album_id, :title, :index], order_by: [desc: :album_id, asc: :index]
    Repo.all(q)

    q = from "tracks", select: [:album_id, :title, :index], order_by: [desc: :album_id, asc_nulls_first: :index]
    Repo.all(q)

    q = from t in "tracks", select: %{album_id: t.album_id, duration: sum(t.duration)}, group_by: [t.album_id], having: sum(t.duration) > 3600
    Repo.all(q)
  end

  def demo_joins() do
    q = from t in "tracks", join: a in "albums", on: t.album_id == a.id, select: %{track: t.title, album: a.title}
    Repo.all(q)

    q =
      from t in "tracks",
      join: a in "albums", on: t.album_id == a.id,
      join: ar in "artists", on: a.artist_id == ar.id,
      where: t.duration > 800,
      select: %{album: a.title, track: t.title, artist: ar.name}

    Repo.all(q)

    q =
      from a in "albums",
      join: ar in "artists", on: a.artist_id == ar.id,
      join: t in "tracks", on: t.album_id == a.id,
      where: ar.name == "Bill Evans",
      select: %{track: t.title, album: a.title}

    Repo.all(q)
  end

  def query_parts() do
    albums_by_miles =
      from a in "albums",
      join: ar in "artists", on: a.artist_id == ar.id,
      where: ar.name == "Miles Davis"

    #albums_query = from a in albums_by_miles, select: a.title

    #bindings still available
    albums_query = from [a, ar] in albums_by_miles, select: %{album: a.title, artist: ar.name}

    track_query =
      from a in albums_by_miles,
      join: t in "tracks", on: a.id == t.album_id,
      select: %{track: t.title}

    Repo.all(track_query)

  end

  def named_bindings() do
    albums_by =
      from a in "albums", as: :albums,
      join: ar in "artists", as: :artists, on: a.artist_id == ar.id,
      where: ar.name == "Miles Davis"

    has_named_binding?(albums_by, :albums)

    album_query = from [albums: a] in albums_by, select: a.title
    Repo.all(album_query)
  end
end

#IO.inspect(Practice.QueryModule.query_demo())
#IO.inspect(Practice.QueryModule.dynamic_types("4"))
#IO.inspect(Practice.QueryModule.query_binding("Alux Nahual"))
#IO.inspect(Practice.QueryModule.combine())
#IO.inspect(Practice.QueryModule.ordering())
#IO.inspect(Practice.QueryModule.demo_joins())
#IO.inspect(Practice.QueryModule.query_parts())
IO.inspect(Practice.QueryModule.named_bindings())
