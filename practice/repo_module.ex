defmodule Practice.RepoModule do
  alias MusicDB.{Repo, Artist}

  #this fetch the number or record on a table
  def count_records(table_name) do
    #Repo.aggregate(table_name, :count, :id)
    Repo.count(table_name)
    #Repo.avg(table_name)
  end

  # this methods is for use with scheme defined
  def add_update_delete() do
    Repo.insert(%Artist{name: "Alux"})

    alux = Repo.get_by(Artist, name: "Alux")

    Repo.update(Ecto.Changeset.change(alux, name: "Alux Nahual"))

    alux = Repo.get_by(Artist, name: "Alux Nahual")

    Repo.delete(alux)
  end

  # this methods is for use without scheme defined and interact at low level
  def demo_all() do
    Repo.insert_all("artists", [[name: "Alux Nahual"]])

    Repo.insert_all("artists", [
      %{name: "Tambor de la tribu", inserted_at: DateTime.utc_now()},
      %{name: "Vilma palma", inserted_at: DateTime.utc_now()},
      %{name: "Patricio Rey", inserted_at: DateTime.utc_now()},
      ], returning: [:name])

    Repo.update_all("artists", set: [updated_at: DateTime.utc_now()])

    #Repo.delete_all("tracks")
    #Ecto.Adapters.SQL.query(Repo, "select name from artists")

    Repo.query("select name from artists")
  end

end

IO.inspect(Practice.RepoModule.count_records("tracks"))
#IO.inspect(Practice.RepoModule.add_update_delete())
#IO.inspect(Practice.RepoModule.demo_all())
