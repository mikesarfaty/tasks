defmodule Tasks.Users.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    has_many :todo_items, Tasks.TodoItems.TodoItem

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end

end
