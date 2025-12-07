class CreateSymptoms < ActiveRecord::Migration[8.1]
  def change
    create_table :symptoms do |t|
      t.references :medical_area, null: false, foreign_key: true
      t.string :name,             null: false

      t.timestamps
    end
  end
end
