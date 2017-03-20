class AddTitleToSchedule < ActiveRecord::Migration[5.0]
	def change
		add_column :schedules, :title, :text, default: ""
	end
end
