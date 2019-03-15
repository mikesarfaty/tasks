defmodule TasksWeb.UserController do
  use TasksWeb, :controller

  alias Tasks.Users
  alias Tasks.Users.User

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
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

  def extract_underling_data(underling_info) do
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user(id)
    underling_info = Users.get_all_underlings(id)
    underlings = Enum.map(Users.get_all_underlings(id),
      fn (underling_info) ->
        %{
          name: Enum.at(Tuple.to_list(underling_info), 0),
          title: Enum.at(Tuple.to_list(underling_info), 1),
          is_completed: Enum.at(Tuple.to_list(underling_info), 2),
        }
      end)
    render(conn, "show.html", user: user, underlings: underlings)
  end

  def edit(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    changeset = Users.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

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
