class CreateViewScreens < ActiveRecord::Migration[5.1]
  def change
    create_table :view_screens do |t|
    	t.string :screen_for
      t.timestamps
    end
  end
end
