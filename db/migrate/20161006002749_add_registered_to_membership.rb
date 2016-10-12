class AddRegisteredToMembership < ActiveRecord::Migration[5.0]
  def change
    add_column :memberships, :registered, :boolean
  end
end
