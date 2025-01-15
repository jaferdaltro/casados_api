class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.text :description
      t.boolean :sended, default: false


      t.timestamps
    end
  end
end
