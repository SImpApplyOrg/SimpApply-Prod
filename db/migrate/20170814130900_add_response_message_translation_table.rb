class AddResponseMessageTranslationTable < ActiveRecord::Migration[5.1]
  def self.up
    ResponseMessage.create_translation_table!({
      :message => :text
    }, {
      :migrate_data => true,
      :remove_source_columns => true
    })
  end

  def self.down
    ResponseMessage.drop_translation_table! :migrate_data => true
  end
end
