class CreateAreas < ActiveRecord::Migration[5.0]
  def change
    create_table :areas do |t|
      t.text :name
      t.text :description
      t.text :address
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
