defmodule Tasks.Users.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    has_many :todo_items, Tasks.TodoItems.TodoItem
    belongs_to :supervisor, Tasks.Users.User
    has_many :underlings, Tasks.Users.User

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :supervisor_id])
    |> validate_required([:email])
  end

end
