class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :name
      t.references :winery, index: true, foreign_key: true
      t.text :description
      t.string :api_id

      t.timestamps null: false
    end
  end
end
