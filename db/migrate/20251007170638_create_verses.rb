class CreateVerses < ActiveRecord::Migration[7.2]
  def change
    create_table :verses do |t|
      t.integer :book, null: false
      t.integer :chapter, null: false
      t.boolean :favorite, default: false, null: false
      t.integer :verse, null: false
      t.string :text,  null: false

      t.timestamps
    end
  end
end
