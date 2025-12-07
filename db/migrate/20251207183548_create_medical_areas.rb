class CreateMedicalAreas < ActiveRecord::Migration[8.1]
  def change
    create_table :medical_areas do |t|
      t.string  :name,          null: false
      t.integer :display_order, null: false, default: 0

      t.timestamps
    end
  end
end
