def child_spec(arg) do
  %{
    id: MyModule,
    start: {MyModule, :start_link, [arg]},
    type: worker,
    restart: :permanent,
    shutdown: 500
  }
end
