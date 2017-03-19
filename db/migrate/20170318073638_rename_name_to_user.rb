class RenameNameToUser < ActiveRecord::Migration[5.0]
	def change
		rename_column :users, :name, :user_name
	end
end
