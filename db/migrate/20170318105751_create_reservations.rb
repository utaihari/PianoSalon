class CreateReservations < ActiveRecord::Migration[5.0]
	def change
		create_table :reservations do |t|
			t.integer :user_id
			t.integer :salon_id
			t.integer :condition, default: 0

			t.timestamps
		end
	end
end
