class RenameColumnNameToSalon < ActiveRecord::Migration[5.0]
	def change
		rename_column :salons, :name, :salon_name
	end
end
