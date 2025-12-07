class CreateKampoSymptoms < ActiveRecord::Migration[8.1]
  def change
    create_table :kampo_symptoms do |t|
      t.references :kampo, null: false, foreign_key: true
      t.references :symptom, null: false, foreign_key: true
      t.integer :weight

      t.timestamps
    end
  end
end
