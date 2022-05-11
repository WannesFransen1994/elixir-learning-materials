# Set up a DB: https://github.com/WannesFransen1994/elixir-learning-materials/blob/master/phoenix-framework/01-Framework-fundamentals/01-getting-started/assignment.md
alias DemoAssociations.UserContext.User
alias DemoAssociations.TaskContext.Task
alias DemoAssociations.Repo

# Create User
attrs = %{name: "test user"}
empty_user = %User{}
new_user = empty_user |> User.changeset(attrs) |> Repo.insert!()

attrs = %{name: "test user 2"}
new_user = empty_user |> User.changeset(attrs) |> Repo.insert!()

# Create Task(s)
attrs = %{title: "test task"}
empty_task = %Task{}
new_task = empty_task |> Task.changeset(attrs) |> Repo.insert!()

attrs = %{title: "test task 2"}
new_task2 = empty_task |> Task.changeset(attrs) |> Repo.insert!()

# Verify Users
Repo.all(User)

# Verify Tasks
Repo.all(Task)

# Now create a &assign_user_to_task_changeset/2
task1 = Repo.get_by!(Task, title: "test task")
user = Repo.get_by!(User, name: "test user")
user2 = Repo.get_by!(User, name: "test user 2")
Task.assign_user_to_task_changeset(task1, user)

# Error "Please preload your associations before manipulating them through changeset"
preloaded_task1 = Repo.preload(task1, :users)
update_changeset = Task.assign_user_to_task_changeset(preloaded_task1, user)
# Note: Only preload the "main" association!
# Now persist to database
Repo.update!(update_changeset)

preloaded_task1 = Repo.get_by!(Task, title: "test task") |> Repo.preload( :users)
update_changeset = Task.assign_user_to_task_changeset(preloaded_task1, user2)
Repo.update!(update_changeset)

# Task you can do @home: try to assign tasks to users (other way around)
