class CreateShipments < ActiveRecord::Migration[5.0]
  def change
    create_table :shipments do |t|
      t.integer :order_id
      t.datetime :ship_at
      t.datetime :arrival_at
      t.text :message

      t.timestamps
    end
  end
end
