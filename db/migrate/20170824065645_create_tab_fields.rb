class CreateTabFields < ActiveRecord::Migration[5.1]
  def change
    create_table :tab_fields do |t|
    	t.references :job_application_question, foreign_key: true
    	t.belongs_to :screen_tab, index: true
      t.timestamps
    end
  end
end
