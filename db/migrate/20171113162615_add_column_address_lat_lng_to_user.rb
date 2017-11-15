class AddColumnAddressLatLngToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :address, :text
    add_column :users, :lat, :decimal
    add_column :users, :lng, :decimal
  end
end
