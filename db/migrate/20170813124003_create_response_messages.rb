class CreateResponseMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :response_messages do |t|
      t.text :message
      t.string :message_type

      t.timestamps
    end
  end
end
