class CreateBookingRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :booking_rooms do |t|
      t.text :description
      t.string :name
      t.integer :capacity

      t.timestamps
    end
  end
end
