class RenameNameToArea < ActiveRecord::Migration[5.0]
	def change
		rename_column :areas, :name, :area_name
	end
end
