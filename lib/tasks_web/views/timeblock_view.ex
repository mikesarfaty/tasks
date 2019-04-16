defmodule TasksWeb.TimeblockView do
  use TasksWeb, :view
  alias TasksWeb.TimeblockView

  def render("index.json", %{timeblocks: timeblocks}) do
    %{data: render_many(timeblocks, TimeblockView, "timeblock.json")}
  end

  def render("show.json", %{timeblock: timeblock}) do
    %{data: render_one(timeblock, TimeblockView, "timeblock.json")}
  end

  def render("timeblock.json", %{timeblock: timeblock}) do
    timediff =
      if timeblock.end_time do
        NaiveDateTime.diff(timeblock.end_time, timeblock.start_time)
      else
        0
      end

    %{
      id: timeblock.id,
      start_time: timeblock.start_time,
      end_time: timeblock.end_time,
      todo_item_id: timeblock.todo_item_id,
      duration: timediff
    }
  end
end
