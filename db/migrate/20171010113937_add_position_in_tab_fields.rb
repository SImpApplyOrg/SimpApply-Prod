class AddPositionInTabFields < ActiveRecord::Migration[5.1]
  def change
    add_column :tab_fields, :position, :integer
  end
end
