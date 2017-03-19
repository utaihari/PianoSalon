class CreateSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :schedules do |t|
      t.integer :salon_id
      t.datetime :start_time
      t.datetime :end_time
      t.integer :recruitment_numbers
      t.text :notes

      t.timestamps
    end
  end
end
