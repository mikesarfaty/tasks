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

  def check_for_errors(conn, todo_item, todo_item_params) do
  end

  def update(conn, %{"id" => id, "todo_item" => todo_item_params}) do
    todo_item = TodoItems.get_todo_item(id)
    {new_time_spent, _} = Float.parse(Map.get(todo_item_params, "time_spent"))
    

    if todo_item.time_spent != new_time_spent do
      if get_session(conn, :user_id) != todo_item.user.id do
        error(conn, todo_item, "You can only track time for yourself!")
      end
      if Float.round(new_time_spent * 4) !=  new_time_spent * 4 do
        error(conn, todo_item, "Please enter in increments of quarter hours")
      end
    end

    user = if Map.get(todo_item_params, "assignee") != "" do
      Users.get_user_by_email(Map.get(todo_item_params, "assignee"))
    else
      todo_item.user
    end

    if user do
      all_params = todo_item_params
                   |> Map.delete("assignee")
                   |> Map.put("user_id", user.id)

      case TodoItems.update_todo_item(todo_item, all_params) do
        {:ok, todo_item} ->
          conn
          |> put_flash(:info, "Todo item updated successfully.")
          |> redirect(to: Routes.todo_item_path(conn, :show, todo_item))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", todo_item: todo_item, changeset: changeset)
      end
    else
        if user == nil do
          error(conn, todo_item, "That user does not exist!")
        end
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
