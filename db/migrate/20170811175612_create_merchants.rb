class CreateMerchants < ActiveRecord::Migration[5.1]
  def change
    create_table :merchants do |t|
      t.string :uuid
      t.text :token
      t.string :mobile_no
      t.boolean :is_created, default: false

      t.timestamps
    end
  end
end
