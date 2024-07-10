class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :user_id, null: false
      t.integer :ticket_id, null: false
      t.timestamps
    end
    add_foreign_key :comments, :users
    add_foreign_key :comments, :tickets

  end
end
