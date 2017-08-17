class AddColumnIsTrailAccountToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_trail_account, :boolean, default: true
  end
end
