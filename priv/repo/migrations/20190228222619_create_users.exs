defmodule Tasks.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :supervisor_id, references(:users, on_delete: :nilify_all)

      timestamps()
    end

  end
end
