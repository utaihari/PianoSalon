class AddScheduleIdToReservation < ActiveRecord::Migration[5.0]
	def change
		add_column :reservations, :schedule_id, :integer
		remove_column :reservations, :salon_id, :integer
	end
end
