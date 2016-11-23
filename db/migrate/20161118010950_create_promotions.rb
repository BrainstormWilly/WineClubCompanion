class CreatePromotions < ActiveRecord::Migration[5.0]
  def change
    create_table :promotions do |t|
      t.string :title
      t.text :body
      t.integer :sub_type
      t.string :url

      t.timestamps
    end
  end
end
