defmodule TasksWeb.TodoItemController do
  use TasksWeb, :controller

  alias Tasks.TodoItems
  alias Tasks.TodoItems.TodoItem
  alias Tasks.Users

  def index(conn, _params) do
    todoitems = TodoItems.list_todoitems()
    render(conn, "index.html", todoitems: todoitems)
  end

  def new(conn, _params) do
    changeset = TodoItems.change_todo_item(%TodoItem{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"todo_item" => todo_item_params}) do
    user = Users.get_user_by_email(Map.get(todo_item_params, "assignee"))
    all_params = todo_item_params
                 |> Map.put("user_id", get_session(conn, :user_id))
                 |> Map.delete("assignee")
    IO.inspect(all_params)
    case TodoItems.create_todo_item(all_params) do
      {:ok, todo_item} ->
        conn
        |> put_flash(:info, "Todo item created successfully.")
        |> redirect(to: Routes.todo_item_path(conn, :show, todo_item))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    todo_item = TodoItems.get_todo_item(id)
    render(conn, "show.html", todo_item: todo_item)
  end

  def edit(conn, %{"id" => id}) do
    todo_item = TodoItems.get_todo_item(id)
    changeset = TodoItems.change_todo_item(todo_item)
    render(conn, "edit.html", todo_item: todo_item, changeset: changeset)
  end

  def error(conn, todo_item, msg) do
    conn
    |> put_flash(:error, msg)
    |> redirect(to: Routes.todo_item_path(conn, :show, todo_item))
  end

  def update_conn(conn, todo_item, all_params) do
      case TodoItems.update_todo_item(todo_item, all_params) do
        {:ok, todo_item} ->
          conn
          |> put_flash(:info, "Todo item updated successfully.")
          |> redirect(to: Routes.todo_item_path(conn, :show, todo_item))

        {:error, %Ecto.Changeset{} = changeset} ->
          IO.inspect(changeset)
          render(conn, "edit.html", todo_item: todo_item, changeset: changeset)
      end
  end

  def update(conn, %{"id" => id, "todo_item" => todo_item_params}) do
    todo_item = TodoItems.get_todo_item(id)
    old_time_spent = todo_item.time_spent
    {new_time_spent, _} = Float.parse(todo_item_params["time_spent"])
    case {todo_item_params["assignee"], new_time_spent} do
      {"", ^old_time_spent} -> # assignee and time spent
        update_conn(conn, todo_item,
          todo_item_params
          |> Map.put("user_id", todo_item.user.id))
      {"", new_time_spent} ->
        cond do 
          get_session(conn, :user_id) != todo_item.user.id ->
            error(conn, todo_item, "you can only edit times for yourself!")
          (new_time_spent * 4) == Float.round(new_time_spent * 4) ->
            update_conn(conn, todo_item,
              todo_item_params
              |> Map.put("user_id", todo_item.user.id))
          true ->
            error(conn, todo_item, "You must enter time in incremnts of quarter hours")
        end
      {new_assignee, ^old_time_spent} ->
        user = Users.get_user_by_email(new_assignee)
        if user do
          update_conn(conn, todo_item,
            todo_item_params
            |> Map.put("user_id", user))
        else
          error(conn, todo_item, "that user does not exist!")
        end
      {_, _} ->
        error(conn, todo_item, "Uknown Error")
    end
  end

  def delete(conn, %{"id" => id}) do
    todo_item = TodoItems.get_todo_item!(id)
    {:ok, _todo_item} = TodoItems.delete_todo_item(todo_item)

    conn
    |> put_flash(:info, "Todo item deleted successfully.")
    |> redirect(to: Routes.todo_item_path(conn, :index))
  end
end
