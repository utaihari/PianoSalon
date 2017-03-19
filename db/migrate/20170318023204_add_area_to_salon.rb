class AddAreaToSalon < ActiveRecord::Migration[5.0]
  def change
    add_column :salons, :area_id, :integer
  end
end
