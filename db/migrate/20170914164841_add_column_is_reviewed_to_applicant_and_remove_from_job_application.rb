class AddColumnIsReviewedToApplicantAndRemoveFromJobApplication < ActiveRecord::Migration[5.1]
  def change
    remove_column :job_applications, :is_reviewed, :boolean, default: false
    add_column :applicants, :is_reviewed, :boolean, default: :false
  end
end
