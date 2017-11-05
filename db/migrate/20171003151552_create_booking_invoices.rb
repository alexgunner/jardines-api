class CreateBookingInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :booking_invoices do |t|
      t.references :reservation, index: true
      t.integer :total
      t.integer :status

      t.timestamps
    end

    add_foreign_key :booking_invoices, :booking_reservations, column: :reservation_id
  end
end
