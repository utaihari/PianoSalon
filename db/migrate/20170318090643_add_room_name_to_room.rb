class AddRoomNameToRoom < ActiveRecord::Migration[5.0]
	def change
		add_column :rooms, :room_name, :text, default: ""
	end
end
