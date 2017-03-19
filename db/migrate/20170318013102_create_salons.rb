class CreateSalons < ActiveRecord::Migration[5.0]
  def change
    create_table :salons do |t|
      t.integer :user_id
      t.text :name
      t.text :description

      t.timestamps
    end
  end
end
