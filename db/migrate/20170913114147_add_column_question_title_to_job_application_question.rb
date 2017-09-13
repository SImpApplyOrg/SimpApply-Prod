class AddColumnQuestionTitleToJobApplicationQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :job_application_questions, :question_title, :text
  end
end
