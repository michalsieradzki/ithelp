class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.references :ticket, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :action_type, null: false
      t.json :details
      t.timestamps
    end
  end
end
