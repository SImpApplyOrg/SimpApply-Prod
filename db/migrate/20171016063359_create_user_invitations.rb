class CreateUserInvitations < ActiveRecord::Migration[5.1]
  def change
    create_table :user_invitations do |t|
      t.integer :sender_id
      t.integer :receiver_id 
      t.string :status, default: "pending"
      t.string :token
      t.timestamps
    end
  end
end
