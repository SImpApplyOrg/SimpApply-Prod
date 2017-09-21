class CreateMessageTags < ActiveRecord::Migration[5.1]
  def change
    create_table :message_tags do |t|
      t.string :tag_name
      t.string :tag_value
      t.references :job_application_question
      t.boolean :is_editable, default: true

      t.timestamps
    end
  end
end
