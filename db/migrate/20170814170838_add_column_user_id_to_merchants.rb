class AddColumnUserIdToMerchants < ActiveRecord::Migration[5.1]
  def change
    add_column :merchants, :user_id, :integer
  end
end
