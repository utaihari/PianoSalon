class CreatePages < ActiveRecord::Migration[5.0]
	def change
		create_table :pages do |t|
			t.text :contents, default: ""

			t.timestamps
		end
	end
end
