class AddRefsToCaseNotes < ActiveRecord::Migration[8.1]
  def change
    add_reference :case_notes, :kampo, foreign_key: true
    add_reference :case_notes, :search_session, foreign_key: true
  end
end
