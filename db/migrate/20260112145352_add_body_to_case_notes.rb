class AddBodyToCaseNotes < ActiveRecord::Migration[8.1]
  def change
    add_column :case_notes, :body, :text, null: false, default: ""
  end
end
