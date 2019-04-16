defmodule Tasks.Timeblocks.Timeblock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "timeblocks" do
    field :end_time, :naive_datetime
    field :start_time, :naive_datetime
    belongs_to :todo_item, Tasks.TodoItems.TodoItem

    timestamps()
  end

  def to_hms(timeblocks) do
    seconds =
      timeblocks
      |> Enum.map(fn timeblock ->
        if timeblock.end_time do
          NaiveDateTime.diff(timeblock.end_time, timeblock.start_time)
        else
          0
        end
      end)
      |> Enum.sum
      days = trunc(seconds / 86400)
      hours = trunc(rem(seconds, 86400) / 3600)
      minutes = trunc(rem(seconds, 3600) / 60)
      seconds = trunc(rem(seconds, 60))
      "#{days}d, #{hours}h, #{minutes}m, #{seconds}s"
  end

  @doc false
  def changeset(timeblock, attrs) do
    timeblock
    |> cast(attrs, [:start_time, :end_time, :todo_item_id])
    |> validate_required([])
  end
end
