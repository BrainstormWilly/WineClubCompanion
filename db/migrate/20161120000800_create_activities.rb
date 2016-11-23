class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.string :name
      t.string :activity_type
      t.string :activity_sub_type
      t.references :winery, foreign_key: true

      t.timestamps
    end
  end
end
