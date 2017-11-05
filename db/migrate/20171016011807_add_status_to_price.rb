class AddStatusToPrice < ActiveRecord::Migration[5.1]
  def change
    add_column :booking_prices, :status, :integer
  end
end
