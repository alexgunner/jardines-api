class CreateBookingStatusChangeMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :booking_status_change_messages do |t|
      t.references :status_change, index: true
      t.text :body

      t.timestamps
    end

    add_foreign_key :booking_status_change_messages, :booking_status_changes, column: :status_change_id
  end
end
