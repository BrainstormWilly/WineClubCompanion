class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true
      t.references :delivery, foreign_key: true
      t.boolean :activated
      t.timestamps
    end
  end
end
