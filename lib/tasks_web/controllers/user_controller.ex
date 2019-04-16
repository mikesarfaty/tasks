defmodule TasksWeb.UserController do
  use TasksWeb, :controller

  alias Tasks.Users
  alias Tasks.Users.User
  alias Tasks.TodoItems

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Users.change_user(%User{})

    all_emails =
      Users.list_users()
      |> Enum.map(fn u ->
        u.email
      end)

    render(conn, "new.html", changeset: changeset, all_emails: ["" | all_emails])
  end

  def create(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))
        |> put_session(:user_id, user.id)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user(id)

    my_tasks = TodoItems.get_tasks_for_user(id)

    underlings =
      Enum.map(
        Users.get_all_underlings(id),
        fn underling_info ->
          %{
            name: Enum.at(Tuple.to_list(underling_info), 0),
            title: Enum.at(Tuple.to_list(underling_info), 1),
            is_completed: Enum.at(Tuple.to_list(underling_info), 2)
          }
        end
      )

    underling_emails = Users.get_underling_emails(id)

    render(conn, "show.html",
      user: user,
      underlings: underlings,
      underling_emails: underling_emails,
      tasks: my_tasks
    )
  end

  def edit(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    changeset = Users.change_user(user)

    all_emails =
      Users.list_users()
      |> Enum.map(fn u ->
        u.email
      end)

    render(conn, "edit.html", user: user, changeset: changeset, all_emails: ["" | all_emails])
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    user_params =
      if user_params["new_supervisor"] == "" do
        Map.put(user_params, "supervisor_id", nil)
      else
        Map.put(user_params, "supervisor_id", Users.get_user_by_email(user_params["new_supervisor"]).id)
      end

    case Users.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    {:ok, _user} = Users.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
