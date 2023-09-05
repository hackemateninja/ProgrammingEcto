#---
# Excerpted from "Programming Ecto",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/wmecto for more book information.
#---
##############################################
## Ecto Playground
#
# This script sets up a sandbox for experimenting with Ecto. To
# use it, just add the code you want to try into the Playground.play/0
# function below, then execute the script via mix:
#
#   mix run priv/repo/playground.exs
#
# The return value of the play/0 function will be written to the console
#
# To get the test data back to its original state, just run:
#
#   mix ecto.reset
#
alias MusicDB.Repo
alias MusicDB.{Artist, Album, Track, Genre, Log, AlbumWithEmbeds, ArtistEmbed, TrackEmbed}
alias Ecto.Multi

import Ecto.Query
import Ecto.Changeset

defmodule Playground do
  # this is just to hide the "unused import" warnings while we play
  def this_hides_warnings do
    [Artist, Album, Track, Genre, Repo, Multi, Log, AlbumWithEmbeds, ArtistEmbed, TrackEmbed]
    from(a in "artists")
    from(a in "artists", where: a.id == 1)
    cast({%{}, %{}}, %{}, [])
  end

  def play do

    #repo provides this methods
    Repo.insert(%Artist{name: "Dizzy Gillespie"})

    dizzy = Repo.get_by(Artist, name: "Dizzy Gillespie")

    Repo.update(Ecto.Changeset.change(dizzy, name: "John Birks Gillespie"))

    dizzy = Repo.get_by(Artist, name: "John Birks Gillespie")

    Repo.delete(dizzy)

    #low level functions with map

    Repo.insert_all("artists", [[name: "alux"]])


    Repo.insert_all("artists", [
      %{name: "Max Roach", inserted_at: DateTime.utc_now()},
      %{name: "Art blakey", inserted_at: DateTime.utc_now()}
    ])

    #low level functions with keyword list

    Repo.insert_all("artists", [
      [name: "Max Roach", inserted_at: DateTime.utc_now()],
      [name: "Art blakey", inserted_at: DateTime.utc_now()]
    ])

    Repo.update_all("artists", set: [updated_at: DateTime.utc_now()])

    #asking for values
    Repo.insert_all("artists", [%{name: "Max Roach"}, %{name: "Art Blakey"}], returning: [:id, :name])

    #raw queries
    Ecto.Adapters.SQL.query(Repo, "select * from artists where id=1")

    #this way is valid too
    Repo.query("select * from artists where id=1")

    #customizing your Repo
    Repo.aggregate("albums", :count, :id)

    #simple query
    query = from "artists", select: [:name]

    #using repo to see how ecto converts this into sql
    Repo.to_sql(:all, query)

    Repo.all(queryn)

    #prefix in postgresql means the schema wher the table is located
    query = from "artists", prefix: "public", select: [:name]

    #where
    q = from "artists", where: [name: "Bill Evans"], select: [:id, :name]

    artist = "alux"

    query = from "artists", where: [name: ^artist], select: [:id, :name]

    #suposing that we get a string inseatd a integer
    artist_id = "1"

    # this should give us a error because id need to a integer
    q = from "artists", where: [id: ^artist_id], select: [:name]


    # this should convert our value into a integer
    q = from "artists", where: [id: type(^artist_id, :integer)], select: [:name]


    #binding variable
    q = from a in "artists", where: a.name == "alux", select: [:id, :name]

    q = from a in "artists", where: a.inserted_at < ago(1, "year"), select: [:id, :name]

    q = from a in "artists", where: fragment("lower(?)", a.name) == "miles davis", select: [:id, :name]

    #combining results with union and union_all

    tracks_query = from t in "tracks", select: t.title
    union_query = from a in "albums", select: a.title,
    union: ^tracks_query

    Repo.all(union_query)


    #ordering and grouping
    q = from t in "tracks", select: [t.album_id, t.title, t.index], order_by: [t.album_id, t.index]
    q = from a in "artists", select: [a.name], order_by: [desc: a.name]
  end

end

# add your test code to Playground.play above - this will execute it
# and write the result to the console
IO.inspect(Playground.play())
