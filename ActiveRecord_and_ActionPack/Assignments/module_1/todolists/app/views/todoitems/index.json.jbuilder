json.array!(@todoitems) do |todoitem|
  json.extract! todoitem, :id, :due_date, :title, :description, :completed
  json.url todoitem_url(todoitem, format: :json)
end
