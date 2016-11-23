class CreateDeliveries < ActiveRecord::Migration[5.0]
  def change
    create_table :deliveries do |t|
      t.integer :channel
      t.references :activity, foreign_key: true

      t.timestamps
    end
  end
end
