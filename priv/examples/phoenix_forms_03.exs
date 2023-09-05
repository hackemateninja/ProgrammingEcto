#---
# Excerpted from "Programming Ecto",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/wmecto for more book information.
#---
defmodule MyApp.Address do
  import Ecto.Changeset
  use Ecto.Schema

  embedded_schema do
    field :street, :string
    field :city, :string
  end

  def changeset(address, params) do
    cast(address, params, [:street, :city])
  end
end

_ = """
schema "users" do
  field :name, :string
  field :age, :integer

  embeds_one :address, Address
end
"""

defmodule MyApp.User do
  import Ecto.Changeset

  def changeset(user, params) do
    user
    |> cast(params, [:name, :age])
    |> cast_embed(:address)
    |> validate_number(:age, greater_than: 0,
         message: "you are not yet born")
  end
end

_ = """
<%= form_for @changeset, user_path(@conn, :create), fn f -> %>
  Name: <%= text_input f, :name %> <%= error_tag f, :name %>
  Age: <%= number_input f, :age %> <%= error_tag f, :age %>
  <%= inputs_for f, :address, fn fa -> %>
    Street: <%= text_input fa, :street %> <%= error_tag fa, :street %>
    City: <%= text_input fa, :city %> <%= error_tag fa, :city %>
  <% end %>
  <%= submit "Submit" %>
<% end %>
"""

_ = """
<%= inputs_for f, :address, append: [%Address{}], fn fa -> %>
  Street: <%= text_input fa, :street %> <%= error_tag fa, :street %>
  City: <%= text_input fa, :city %> <%= error_tag fa, :city %>
<% end %>
"""

