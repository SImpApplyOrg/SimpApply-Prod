class AddColumnIsActiveToViewScreens < ActiveRecord::Migration[5.1]
  def change
    add_column :view_screens, :is_active, :boolean, default: true
  end
end
