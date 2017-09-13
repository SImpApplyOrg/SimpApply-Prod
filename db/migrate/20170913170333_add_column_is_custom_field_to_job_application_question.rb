class AddColumnIsCustomFieldToJobApplicationQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :job_application_questions, :is_custom_field, :boolean, default: false
  end
end
