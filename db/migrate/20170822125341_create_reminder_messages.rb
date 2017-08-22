class CreateReminderMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :reminder_messages do |t|
      t.string :reminder_for
      t.integer :remind_after
      t.text :message

      t.timestamps
    end
  end
end
