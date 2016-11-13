json.array!(@todolists) do |todolist|
  json.extract! todolist, :id, :list_name, :list_due_date
  json.url todolist_url(todolist, format: :json)
end
