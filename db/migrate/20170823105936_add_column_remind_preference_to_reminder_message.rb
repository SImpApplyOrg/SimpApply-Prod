class AddColumnRemindPreferenceToReminderMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :reminder_messages, :remind_preference, :string
  end
end
