class CreateBookingRoomReservations < ActiveRecord::Migration[5.1]
  def change
    create_table :booking_room_reservations do |t|
      t.references :room, index: true
      t.references :price, index: true
      t.references :reservation, index: true

      t.timestamps
    end

    add_foreign_key :booking_room_reservations, :booking_rooms, column: :room_id
    add_foreign_key :booking_room_reservations, :booking_prices, column: :price_id
    add_foreign_key :booking_room_reservations, :booking_reservations, column: :reservation_id
  end
end
