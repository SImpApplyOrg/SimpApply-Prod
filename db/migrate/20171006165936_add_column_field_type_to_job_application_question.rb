class AddColumnFieldTypeToJobApplicationQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :job_application_questions, :field_type, :string
  end
end
