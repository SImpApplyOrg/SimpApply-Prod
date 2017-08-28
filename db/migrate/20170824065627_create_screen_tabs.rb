class CreateScreenTabs < ActiveRecord::Migration[5.1]
  def change
    create_table :screen_tabs do |t|
      t.belongs_to :view_screen, index: true
      t.string :name
      t.integer :position
      t.boolean :is_active, default: true
      t.timestamps
    end
  end
end
