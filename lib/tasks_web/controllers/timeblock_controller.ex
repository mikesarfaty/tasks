defmodule TasksWeb.TimeblockController do
  use TasksWeb, :controller

  alias Tasks.Timeblocks
  alias Tasks.Timeblocks.Timeblock

  action_fallback TasksWeb.FallbackController

  def index(conn, %{"task_id" => task_id}) do
    timeblocks = Timeblocks.list_timeblocks(task_id)
    render(conn, "index.json", timeblocks: timeblocks)
  end

  def index(conn, _params) do
    timeblocks = Timeblocks.list_timeblocks()
    render(conn, "index.json", timeblocks: timeblocks)
  end

  def create(conn, %{"timeblock" => timeblock_params}) do
    timeblock_params =
      timeblock_params
      |> Map.put("start_time", NaiveDateTime.utc_now())

    case Timeblocks.create_timeblock(timeblock_params) do
      {:ok, %Timeblock{} = timeblock} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.timeblock_path(conn, :show, timeblock))
        |> render("show.json", timeblock: timeblock)

      {_, error_msg} ->
        IO.inspect(error_msg)
    end
  end

  def show(conn, %{"id" => id}) do
    timeblock = Timeblocks.get_timeblock!(id)
    render(conn, "show.json", timeblock: timeblock)
  end

  def update(conn, %{"id" => id, "timeblock" => timeblock_params}) do
    timeblock = Timeblocks.get_timeblock!(id)

    with {:ok, %Timeblock{} = timeblock} <-
           Timeblocks.update_timeblock(timeblock, timeblock_params) do
      render(conn, "show.json", timeblock: timeblock)
    end
  end

  def update(conn, %{"id" => id, "complete_block" => true}) do
    timeblock = Timeblocks.get_timeblock!(id)

    with {:ok, %Timeblock{} = timeblock} <-
           Timeblocks.update_timeblock(timeblock, %{:end_time => NaiveDateTime.utc_now()}) do
      render(conn, "show.json", timeblock: timeblock)
    end
  end

  def delete(conn, %{"id" => id}) do
    timeblock = Timeblocks.get_timeblock!(id)

    with {:ok, %Timeblock{}} <- Timeblocks.delete_timeblock(timeblock) do
      send_resp(conn, :no_content, "")
    end
  end
end
