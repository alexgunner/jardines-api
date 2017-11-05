class CreateBookingReservations < ActiveRecord::Migration[5.1]
  def change
    create_table :booking_reservations do |t|
      t.references :user, foreign_key: true, index: true
      t.date :start_date
      t.date :end_date
      t.integer :arrival_time
      t.integer :status
      t.text :special_details
      t.string :pin

      t.timestamps
    end
  end
end
