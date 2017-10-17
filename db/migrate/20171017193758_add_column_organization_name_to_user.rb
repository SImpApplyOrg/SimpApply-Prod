class AddColumnOrganizationNameToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :organization_name, :string
  end
end
