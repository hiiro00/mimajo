class CreateVillages < ActiveRecord::Migration[5.2]
  def change
    create_table :villages do |t|
      t.integer :roomNum
      t.integer :villageNum
      t.string :name
      t.string :position
      t.string :theme
      t.string :email

      t.timestamps
    end
  end
end
