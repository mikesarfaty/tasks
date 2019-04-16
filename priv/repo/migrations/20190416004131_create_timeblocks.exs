defmodule Tasks.Repo.Migrations.CreateTimeblocks do
  use Ecto.Migration

  def change do
    create table(:timeblocks) do
      add :start_time, :naive_datetime, default: fragment("now()")
      add :end_time, :naive_datetime
      add :todo_item_id, references(:todoitems, on_delete: :delete_all)

      timestamps()
    end

    create index(:timeblocks, [:todo_item_id])
  end
end
