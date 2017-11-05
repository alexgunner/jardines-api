class CreateAggregatedUserData < ActiveRecord::Migration[5.1]
  def change
    create_table :aggregated_user_data do |t|
      t.references :user, foreign_key: true
      t.string :email

      t.timestamps
    end
  end
end
