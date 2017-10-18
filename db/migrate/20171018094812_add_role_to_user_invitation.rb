class AddRoleToUserInvitation < ActiveRecord::Migration[5.1]
  def change
    add_column :user_invitations, :role, :string
  end
end
