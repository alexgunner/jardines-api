class CreateBookingStatusChanges < ActiveRecord::Migration[5.1]
  def change
    create_table :booking_status_changes do |t|
      t.integer :old_status
      t.integer :new_status
      t.references :object, polymorphic: true, index: true

      t.timestamps
    end
  end
end
