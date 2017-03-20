class ChangeColumnDefaultToSchedule < ActiveRecord::Migration[5.0]
	def change
		change_column :schedules, :recruitment_numbers, :integer, default: 0
	end
end
