defmodule Tasks.TodoItems do
  @moduledoc """
  The TodoItems context.
  """

  import Ecto.Query, warn: false
  alias Tasks.Repo

  alias Tasks.TodoItems.TodoItem

  @doc """
  Returns the list of todoitems.

  ## Examples

      iex> list_todoitems()
      [%TodoItem{}, ...]

  """
  def list_todoitems do
    Repo.all from TodoItem,
      preload: [user: []]
  end

  @doc """
  Gets a single todo_item.

  Raises `Ecto.NoResultsError` if the Todo item does not exist.

  ## Examples

      iex> get_todo_item!(123)
      %TodoItem{}

      iex> get_todo_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo_item!(id), do: Repo.get!(TodoItem, id)

  def get_todo_item(id) do
    Repo.one from t in TodoItem,
      where: t.id == ^id,
      preload: [user: []]
  end


  @doc """
  Creates a todo_item.

  ## Examples

      iex> create_todo_item(%{field: value})
      {:ok, %TodoItem{}}

      iex> create_todo_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo_item(attrs \\ %{}) do
    %TodoItem{}
    |> TodoItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a todo_item.

  ## Examples

      iex> update_todo_item(todo_item, %{field: new_value})
      {:ok, %TodoItem{}}

      iex> update_todo_item(todo_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo_item(%TodoItem{} = todo_item, attrs) do
    todo_item
    |> TodoItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TodoItem.

  ## Examples

      iex> delete_todo_item(todo_item)
      {:ok, %TodoItem{}}

      iex> delete_todo_item(todo_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo_item(%TodoItem{} = todo_item) do
    Repo.delete(todo_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo_item changes.

  ## Examples

      iex> change_todo_item(todo_item)
      %Ecto.Changeset{source: %TodoItem{}}

  """
  def change_todo_item(%TodoItem{} = todo_item) do
    TodoItem.changeset(todo_item, %{})
  end
end
