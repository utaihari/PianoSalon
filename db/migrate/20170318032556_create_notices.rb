class CreateNotices < ActiveRecord::Migration[5.0]
	def change
		create_table :notices do |t|
			t.integer :user_id
			t.boolean :is_checked, default: false 
			t.text :description, default: ""
			t.text :title, default: ""

			t.timestamps
		end
	end
end
