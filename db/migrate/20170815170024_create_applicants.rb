class CreateApplicants < ActiveRecord::Migration[5.1]
  def change
    create_table :applicants do |t|
      t.references :merchant, foreign_key: true
      t.references :user, foreign_key: true
      t.string :mobile_no
      t.text :token

      t.timestamps
    end
  end
end
