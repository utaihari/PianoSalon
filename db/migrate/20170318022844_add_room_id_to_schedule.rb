class AddRoomIdToSchedule < ActiveRecord::Migration[5.0]
  def change
    add_column :schedules, :room_id, :integer
  end
end
