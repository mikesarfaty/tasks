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

    underling_emails =
      Enum.map(Users.get_underling_emails(get_session(conn, :user_id)), fn underling ->
        underling
      end)

    this_user = Users.get_user(get_session(conn, :user_id))

    render(conn, "new.html",
      changeset: changeset,
      underling_emails: [this_user.email | underling_emails]
    )
  end

  def create(conn, %{"todo_item" => todo_item_params}) do
    all_params =
      todo_item_params
      |> Map.put("user_id", Users.get_user_by_email(todo_item_params["assignee"]).id)

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
    {id_int, _} = Integer.parse(id)

    {timeblock_id, in_progress} =
      case Tasks.Timeblocks.list_timeblocks()
           |> Enum.filter(fn timeblock ->
             timeblock.todo_item_id == id_int && timeblock.end_time == nil
           end) do
        [hd] ->
          {hd.id, true}

        [] ->
          {nil, false}

        [hd | _tl] ->
          {hd.id, true}
      end

    IO.inspect(in_progress)

    render(conn, "show.html",
      todo_item: todo_item,
      in_progress: in_progress,
      timeblock_id: timeblock_id,
      time_spent: Tasks.Timeblocks.Timeblock.to_hms(todo_item.timeblocks)
    )
  end

  def edit(conn, %{"id" => id}) do
    todo_item = TodoItems.get_todo_item(id)
    changeset = TodoItems.change_todo_item(todo_item)

    underling_emails =
      Enum.map(Users.get_underling_emails(get_session(conn, :user_id)), fn underling ->
        underling
      end)

    this_user = Users.get_user(get_session(conn, :user_id))

    assignee_list =
      [this_user.email | underling_emails]
      |> Enum.filter(fn email ->
        if todo_item.user == nil do
          true
        else
          email != todo_item.user.email
        end
      end)

    assignee_list =
      if todo_item.user do
        [todo_item.user.email | assignee_list]
      else
        assignee_list
      end

    render(conn, "edit.html",
      todo_item: todo_item,
      changeset: changeset,
      underling_emails: assignee_list
    )
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

    todo_item_params =
      todo_item_params
      |> Map.put("user_id", Users.get_user_by_email(todo_item_params["assignee"]).id)

    update_conn(conn, todo_item, todo_item_params)
  end

  def delete(conn, %{"id" => id}) do
    todo_item = TodoItems.get_todo_item!(id)
    {:ok, _todo_item} = TodoItems.delete_todo_item(todo_item)

    conn
    |> put_flash(:info, "Todo item deleted successfully.")
    |> redirect(to: Routes.todo_item_path(conn, :index))
  end
end
