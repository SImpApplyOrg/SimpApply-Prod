class CreateDefaultSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :default_settings do |t|
      t.integer :default_max_application_limit_for_trail_merchant

      t.timestamps
    end
  end
end
