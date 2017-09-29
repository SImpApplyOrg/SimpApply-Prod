class AddColumnTypeFormQuestionNoToJobApplicationQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :job_application_questions, :type_form_question_no, :string
  end
end
