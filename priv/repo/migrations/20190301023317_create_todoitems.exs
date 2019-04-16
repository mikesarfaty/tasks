defmodule Tasks.Repo.Migrations.CreateTodoitems do
  use Ecto.Migration

  def change do
    create table(:todoitems) do
      add :description, :string, null: false
      add :title, :string, null: false
      add :is_completed, :boolean, default: false, null: false
      add :time_spent, :float, default: 0
      add :user_id, references(:users, on_delete: :nilify_all)

      timestamps()
    end

    create index(:todoitems, [:user_id])
  end
end
