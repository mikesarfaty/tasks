defmodule Tasks.TodoItems.TodoItem do
  use Ecto.Schema
  import Ecto.Changeset


  schema "todoitems" do
    field :description, :string, null: false
    field :is_completed, :boolean, default: false
    field :time_spent, :float, default: 1.0
    field :title, :string, null: false
    belongs_to :user, Tasks.Users.User
    has_many :timeblocks, Tasks.Timeblocks.Timeblock

    timestamps()
  end

  @doc false
  def changeset(todo_item, attrs) do
    todo_item
    |> cast(attrs, [:description, :user_id, :title, :is_completed, :time_spent])
    |> validate_required([:description, :user_id, :title, :is_completed, :time_spent])
  end
end
