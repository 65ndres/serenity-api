class CreateVerseTags < ActiveRecord::Migration[7.2]
  def change
    create_table :verse_tags do |t|
      t.references :verse, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
