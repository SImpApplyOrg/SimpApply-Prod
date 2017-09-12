class AddColumnIsReviewedToJobApplicationAndRemoveFromApplicant < ActiveRecord::Migration[5.1]
  def change
    add_column :job_applications, :is_reviewed, :boolean, default: false
    remove_column :applicants, :is_reviewed, :boolean, default: :false
  end
end
