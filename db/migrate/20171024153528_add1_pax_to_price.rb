class Add1PaxToPrice < ActiveRecord::Migration[5.1]
  def change
  	add_column :booking_prices, :one_guest, :integer
  	add_column :booking_prices, :two_guests, :integer
  	remove_column :booking_prices, :amount
  end
end
