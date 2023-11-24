defmodule Practice.ChangesetModule do
  import Ecto.Changeset
  import Ecto.Query
  alias MusicDB.Album
  alias MusicDB.{Repo, Artist, Genre}

  def create_with_changeset() do
    #changeset = change(%Artist{name: "Tambor de la tribu"})

    artist = Repo.get_by(Artist, name: "Bobby Hutcherson")
    changeset = change(artist, name: "Robert Hutcherson", birth_date: ~D[1941-01-27])

    Repo.update(changeset)
  end

  def create_with_cast() do
    params = %{"name" => "Charlie Parker", "birth_date" => "NULL", "instrument" => "alto sax"}

    changeset = cast(%Artist{}, params, [:name, :birth_date], empty_values: ["", "NULL"])
    changeset.changes
  end

  def validate() do
    params = %{"name" => "Thelonius Monk", "birth_date" => "1917-10-10"}
    changeset =
      %Artist{}
      |>cast(params, [:name, :birth_date])
      |>validate_required([:name, :birth_date])
      |>validate_length(:name, min: 3)

    #changeset

    traverse_errors(changeset, fn{msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  def validate_with_change() do
    params = %{"name" => "Thelonius Monk", "birth_date" => "2117-10-10"}

    changeset =
      %Artist{}
      |>cast(params, [:name, :birth_date])
      |>validate_change(:birth_date, fn :birth_date, birth_date ->
        cond do
          is_nil(birth_date) -> []
          Date.compare(birth_date, Date.utc_today()) == :lt -> []
          true -> [birth_date: "must be in the past"]
        end
      end)
    changeset.errors
  end

  defp validate_in_the_past(changeset, field) do
    validate_change(changeset, field, fn _field, value ->
      cond do
        is_nil(value) -> []
        Date.compare(value, Date.utc_today()) == :lt -> []
        true -> [{field, "must be in the past" }]
      end
    end)
  end

  def validate_with_change_function() do
    params = %{"name" => "Thelonius Monk", "birth_date" => "2117-10-10"}

    changeset =
      %Artist{}
      |>cast(params, [:name, :birth_date])
      |>validate_in_the_past(:birth_date)

    changeset.errors
  end

  def constraints() do
    Repo.insert(%Genre{name: "bebop"})

    params = %{"name" => "bebop"}

    changeset =
      %Genre{}
      |>cast(params, [:name])
      |>validate_required(:name)
      |>validate_length(:name, min: 3)
      |>unique_constraint(:name)
      #|>unsafe_validate_unique(:name)

    case Repo.insert(changeset) do
      {:ok, _genre} -> IO.puts("Succes")
      {:error, changeset} -> IO.inspect(changeset.errors)
    end
  end

  def working_without_schemas() do
    form = %{
      artist_name: :string,
      album_title: :string,
      artist_birth_date: :date,
      release_date: :date,
      genre: :string
    }

    params = %{
      "artist_name" => "Ella Fitzgerald",
      "album_title" => "",
      "artist_birth_date" => "",
      "release_date" => "",
      "genre" => ""
    }

    changeset =
      {%{}, form}
      |>cast(params, Map.keys(form))
      |>validate_in_the_past(:artist_birth_date)
      |>validate_in_the_past(:release_date)

    if changeset.valid? do
      changeset
    else
      changeset.errors
    end
  end


  def working_with_assoc() do
    artist = Repo.get_by(Artist, name: "Miles Davis")
    album = Ecto.build_assoc(artist, :albums, title: "Miles Ahead")
    Repo.insert(album)
  end

  def watch_assoc() do
    artist = Repo.one(from a in Artist, where: a.name == "Miles Davis", preload: :albums)

    Enum.map(artist.albums, &(&1.title))
  end

  def put_assoc_demo() do
    changeset = Repo.get_by(Artist, name: "Bill Evans")
    |>Repo.preload(:albums)
    |>change()
    |>put_assoc(:albums, [%Album{title: "Bill Ahead"}])

    Repo.update(changeset)
  end

end
#IO.inspect(Practice.ChangesetModule.create_with_changeset())
#IO.inspect(Practice.ChangesetModule.create_with_cast())
#IO.inspect(Practice.ChangesetModule.validate())
#IO.inspect(Practice.ChangesetModule.validate_with_change())
#IO.inspect(Practice.ChangesetModule.validate_with_change_function())
#IO.inspect(Practice.ChangesetModule.constraints())
#IO.inspect(Practice.ChangesetModule.working_without_schemas())
#IO.inspect(Practice.ChangesetModule.working_with_assoc())
#IO.inspect(Practice.ChangesetModule.watch_assoc())
#IO.inspect(Practice.ChangesetModule.put_assoc_demo())
