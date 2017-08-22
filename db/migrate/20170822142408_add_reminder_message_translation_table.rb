class AddReminderMessageTranslationTable < ActiveRecord::Migration[5.1]
  def self.up
    ReminderMessage.create_translation_table!({
      :message => :text
    }, {
      :migrate_data => true,
      :remove_source_columns => true
    })
  end

  def self.down
    ReminderMessage.drop_translation_table! :migrate_data => true
  end
end
