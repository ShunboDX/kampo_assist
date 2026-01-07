class CreateSearchSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :search_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.json :conditions, null: false
      t.string :conditions_hash, null: false

      t.timestamps
    end

    add_index :search_sessions, [ :user_id, :conditions_hash ], unique: true
  end
end
