class AddColumnLastReminderAtToMerchantAndJobApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :merchants, :last_reminder_at, :datetime
    add_column :job_applications, :last_reminder_at, :datetime
  end
end
