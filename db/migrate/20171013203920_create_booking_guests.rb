class CreateBookingGuests < ActiveRecord::Migration[5.1]
  def change
    create_table :booking_guests do |t|
      t.string :name
      t.string :id_number
      t.string :email
      t.string :nationality
      t.references :room_reservation, index: true

      t.timestamps
    end

    add_foreign_key :booking_guests, :booking_room_reservations, column: :room_reservation_id
  end
end
