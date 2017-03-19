class AddAdminAndNameAndTelToUser < ActiveRecord::Migration[5.0]
	def change
		add_column :users, :admin, :boolean, default: false
		add_column :users, :name, :text, default: ""
		add_column :users, :kana, :text, default: ""
		add_column :users, :tel, :text, default: ""
	end
end
