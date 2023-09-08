defmodule Practice.ChangesetModule do
  import Ecto.Changeset
  alias MusicDB.{Repo, Artist}

  def create_with_changeset() do
    changeset = change(%Artist{name: "Tambor de la tribu"})

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

    changeset

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
end
#IO.inspect(Practice.ChangesetModule.create_with_changeset())
#IO.inspect(Practice.ChangesetModule.create_with_cast())
#IO.inspect(Practice.ChangesetModule.validate())
IO.inspect(Practice.ChangesetModule.validate_with_change())
