{application,tasks,
             [{applications,[kernel,stdlib,elixir,logger,runtime_tools,
                             gettext,jason,phoenix_pubsub,postgrex,ecto_sql,
                             distillery,phoenix_html,plug_cowboy,phoenix,
                             phoenix_ecto]},
              {description,"tasks"},
              {modules,['Elixir.Tasks','Elixir.Tasks.Application',
                        'Elixir.Tasks.DataCase','Elixir.Tasks.Repo',
                        'Elixir.Tasks.Timeblocks',
                        'Elixir.Tasks.Timeblocks.Timeblock',
                        'Elixir.Tasks.TodoItems',
                        'Elixir.Tasks.TodoItems.TodoItem',
                        'Elixir.Tasks.Users','Elixir.Tasks.Users.User',
                        'Elixir.TasksWeb','Elixir.TasksWeb.ChangesetView',
                        'Elixir.TasksWeb.ChannelCase',
                        'Elixir.TasksWeb.ConnCase','Elixir.TasksWeb.Endpoint',
                        'Elixir.TasksWeb.ErrorHelpers',
                        'Elixir.TasksWeb.ErrorView',
                        'Elixir.TasksWeb.FallbackController',
                        'Elixir.TasksWeb.Gettext',
                        'Elixir.TasksWeb.LayoutView',
                        'Elixir.TasksWeb.PageController',
                        'Elixir.TasksWeb.PageView',
                        'Elixir.TasksWeb.Plugs.FetchSession',
                        'Elixir.TasksWeb.Router',
                        'Elixir.TasksWeb.Router.Helpers',
                        'Elixir.TasksWeb.SessionController',
                        'Elixir.TasksWeb.TimeblockController',
                        'Elixir.TasksWeb.TimeblockView',
                        'Elixir.TasksWeb.TodoItemController',
                        'Elixir.TasksWeb.TodoItemView',
                        'Elixir.TasksWeb.UserController',
                        'Elixir.TasksWeb.UserSocket',
                        'Elixir.TasksWeb.UserView']},
              {registered,[]},
              {vsn,"0.1.0"},
              {mod,{'Elixir.Tasks.Application',[]}}]}.