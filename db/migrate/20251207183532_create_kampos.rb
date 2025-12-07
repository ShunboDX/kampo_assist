class CreateKampos < ActiveRecord::Migration[8.1]
  def change
    create_table :kampos do |t|
      t.string :name,      null: false
      t.string :kana_name, null: false
      t.string :note
      t.string :detail

      t.timestamps
    end
  end
end
