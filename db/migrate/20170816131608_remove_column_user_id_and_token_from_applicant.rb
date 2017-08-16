class RemoveColumnUserIdAndTokenFromApplicant < ActiveRecord::Migration[5.1]
  def change
    remove_column :applicants, :user_id, :integer
    remove_column :applicants, :token, :text
  end
end
