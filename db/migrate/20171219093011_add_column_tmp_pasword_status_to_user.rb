class AddColumnTmpPaswordStatusToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :tmp_pasword_status, :boolean, default: false
  end
end
