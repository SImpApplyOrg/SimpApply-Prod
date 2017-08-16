class CreateJobApplications < ActiveRecord::Migration[5.1]
  def change
    create_table :job_applications do |t|
      t.references :applicant, foreign_key: true
      t.text :token
      t.text :full_response
      t.text :questions
      t.text :answers

      t.timestamps
    end
  end
end
