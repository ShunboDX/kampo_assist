class CreateCaseNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :case_notes do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
