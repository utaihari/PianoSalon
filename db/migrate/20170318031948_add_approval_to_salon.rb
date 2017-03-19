class AddApprovalToSalon < ActiveRecord::Migration[5.0]
	def change
		add_column :salons, :approval, :boolean, default: false
	end
end
