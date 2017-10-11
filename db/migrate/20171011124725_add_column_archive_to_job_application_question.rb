class AddColumnArchiveToJobApplicationQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :job_application_questions, :archive, :boolean, default: false
  end
end
