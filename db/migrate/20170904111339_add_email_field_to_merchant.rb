class AddEmailFieldToMerchant < ActiveRecord::Migration[5.1]
  def change
    add_column :merchants, :email, :string
  end
end
