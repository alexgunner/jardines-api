class CreateBookingPrices < ActiveRecord::Migration[5.1]
  def change
    create_table :booking_prices do |t|
      t.references :room, index: true
      t.integer :amount

      t.timestamps
    end

    add_foreign_key :booking_prices, :booking_rooms, column: :room_id
  end
end
