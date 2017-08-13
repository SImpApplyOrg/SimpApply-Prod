class CreateDefaultSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :default_settings do |t|
      t.integer :max_applicant_size

      t.timestamps
    end
  end
end
