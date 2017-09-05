class CreateJobApplicationQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :job_application_questions do |t|
    	t.string :question
    	t.integer :field_id
      t.timestamps
    end
  end
end
