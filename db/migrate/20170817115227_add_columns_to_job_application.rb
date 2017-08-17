class AddColumnsToJobApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :job_applications, :is_reviewed, :boolean, default: false
    add_column :job_applications, :question_answers, :text
  end
end
