class CreateKampoDiseases < ActiveRecord::Migration[8.1]
  def change
    create_table :kampo_diseases do |t|
      t.references :kampo, null: false, foreign_key: true
      t.references :disease, null: false, foreign_key: true
      t.integer :weight,     null: false, default: 1

      t.timestamps
    end
  end
end
