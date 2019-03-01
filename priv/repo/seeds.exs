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

Repo.insert!(%User{email: "alice@example.com"})
Repo.insert!(%User{email: "mike@sarfaty.com"})
Repo.insert!(%TodoItem{title: "title", description: "desc", user_id: 1})
