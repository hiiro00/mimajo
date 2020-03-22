class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.integer :roomNum
      t.string :name
      t.string :position
      t.string :email

      t.timestamps
    end
  end
end
