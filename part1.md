# Chapter 1 Repo Module

## Ecto and elixir

1. the query sintax was inspired by LINQ in the .NET framework.
2. migrations and relation syntax feel a lot lke ActiveRecord.
3. Ecto is explicit, ecto avoid the magic.
4. Ecto is flexible. ecto is a suite of tools for database.


## Ecto modules

1. Ecto core functionality is contained in six main modules.
2. Repo is the heart and acts as a kind of proxy.
3. The query module contains ectos powerful but elegat API for writing queries.
4. A schema is a kind of map, from database tables to your code. The schema module contails tools to help you create. these maps with ease.
5. Changeset a data structure that captures all aspects of making a change to your data. The changeset module
provides functions for creating and manipulating changeset.
6. the transaction function works great for simple cases, but the multi module can handle even very complex cases.
7. Migration helps you coordinate these changes so that everyone stays in sync.


## how ecto is organized?

1. ecto is actaully to separate packages: ecto and ecto_sql.
2. the ecto package contains some of the core data manipulation features that are useful even if your not in a relational db, these incluse Repo, Query, Schema and Changeset.
3. ecto_sql contains modules needed to communicate with relational database, ecto_sql includes ecto as a dependendy so
if you work with relational db you just need to include ecto_sql.
4. to work with no relational db, you might include only ecto.


## The repository pattern

1. the main characteristic of this pattern is the presence of a single module or class,
called the Repository, through with all communications with the databases passes
2. The repository acts as a stand in for your database, and its the single point of contact, if you want to talk to a database, talk to the repository.
3. With the Repository pattern, the database is front and center, and is a great fit, for a language like 
Elixir wich decouple data and behavior, and favors explicit behavior over implicit.


## The Repo Module

1. The repo module is the heart of Ecto, and just about everything you do will touch Repo, you can permor all the classic CRUD operations using just Repo module alone. The other modules in Ecto make these operations easier, but there a lot you can do with just Repo.


## Putting our Repo to Work
1. Repo is the gateway to our database, and most of the functions in Repo map directly to standard CRUD operations, its one job is sending payloads back and forth to the database.

2. Repo exposes a number of functions that allow us to interact with our database at a low leve, even before we start setting up schemas. These functios are easy to spot because they end with "all", inset_all, update_all
delete_all, and just plain all for queries.

## Customizing your repo

1. Repo module contains everything you need, but may times when we need to call specific behavior  over and over and oer
we can modify by adding a custom behavior. Thats is possible adding Repo aggregate


# Chapter 2 Query module

## Query Basics
The query module uses Elixir macros to create a DSL that sits right in your Elixir code. The DSL syntax feels a lot like Elixir, but it's a little more fluid and makes writing queries feel more natural.