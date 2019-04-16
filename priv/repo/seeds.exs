# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Tasks.Repo.insert!(%Tasks.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#

alias Tasks.Repo
alias Tasks.Users.User
alias Tasks.TodoItems.TodoItem
alias Tasks.Timeblocks.Timeblock

Repo.insert!(%User{email: "alice@example.com"})
Repo.insert!(%User{email: "mike@sarfaty.com", supervisor_id: 1})
Repo.insert!(%User{email: "bob@marley.com", supervisor_id: 1})

Repo.insert!(%TodoItem{title: "Take out the trash", description: "It's gross.", user_id: 1})
Repo.insert!(%TodoItem{title: "Feed the turtles", description: "The turtles are getting really hungry", user_id: 2})
Repo.insert!(%TodoItem{title: "Send a fax", description: "Doesn't matter where, let's just send one.", user_id: 2})
Repo.insert!(%TodoItem{title: "Receive a fax", description: "This might take a while...", user_id: 3})

{:ok, start_time} = NaiveDateTime.new(2019, 4, 1, 10, 0, 0)
{:ok, end_time} = NaiveDateTime.new(2019, 4, 2, 11, 15, 14)
Repo.insert!(%Timeblock{start_time: start_time, end_time: end_time,todo_item_id: 1})
