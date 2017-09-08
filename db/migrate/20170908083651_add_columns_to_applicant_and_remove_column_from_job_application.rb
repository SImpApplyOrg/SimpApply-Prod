class AddColumnsToApplicantAndRemoveColumnFromJobApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :applicants, :full_response, :text
    add_column :applicants, :questions, :text
    add_column :applicants, :answers, :text
    add_column :applicants, :is_reviewed, :boolean
    add_column :applicants, :question_answers, :text
    add_column :applicants, :last_reminder_at, :datetime
    add_column :applicants, :token, :text

    remove_column :job_applications, :full_response, :text
    remove_column :job_applications, :questions, :text
    remove_column :job_applications, :answers, :text
    remove_column :job_applications, :is_reviewed, :boolean
    remove_column :job_applications, :question_answers, :text
    remove_column :job_applications, :last_reminder_at, :datetime
    remove_column :job_applications, :token, :text
  end
end
