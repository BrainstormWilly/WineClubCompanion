class CreatePublications < ActiveRecord::Migration[5.0]
  def change
    create_table :publications do |t|
      t.references :winery, foreign_key: true
      t.integer :activity_id
      t.string :activity_type
      t.datetime :launch_at

      t.timestamps
    end
  end
end
