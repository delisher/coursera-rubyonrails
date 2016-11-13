User.destroy_all
Profile.destroy_all
TodoItem.destroy_all
TodoList.destroy_all

User.create! [
	{ username: 'Fiorina', password_digest: '12345678' },
	{ username: 'Trump', password_digest: '12345678' },
	{ username: 'Carson', password_digest: '12345678' },
	{ username: 'Clinton', password_digest: '12345678' },
]

User.find_by!(username: 'Fiorina').create_profile(gender: 'female', birth_year: 1954, first_name: 'Carly', last_name: 'Fiorina')
User.find_by!(username: 'Trump').create_profile(gender: 'male', birth_year: 1946, first_name: 'Donald', last_name: 'Trump')
User.find_by!(username: 'Carson').create_profile(gender: 'male', birth_year: 1951, first_name: 'Ben', last_name: 'Carson')
User.find_by!(username: 'Clinton').create_profile(gender: 'female', birth_year: 1947, first_name: 'Hillary', last_name: 'Clinton')

User.all.each_with_index do |u,i|
	u.todo_lists.create! [
		{ list_name: i.to_s, list_due_date: Date.today + 1.year }
	]	
end
TodoList.all.each_with_index do |l,i|
	l.todo_items.create! [
		{ title: '1', description: 'first description.', due_date: Date.today + 1.year },
		{ title: '2', description: 'second description.', due_date: Date.today + 1.year },
		{ title: '3', description: 'third description.', due_date: Date.today + 1.year },
		{ title: '4', description: 'fourth description.', due_date: Date.today + 1.year },
		{ title: '5', description: 'fifth description.', due_date: Date.today + 1.year },
	]	
end