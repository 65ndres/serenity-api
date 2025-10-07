class CreateUserInteractions < ActiveRecord::Migration[7.2]
  def change
    create_table :user_interactions do |t|
      t.integer :user_id
      t.boolean :liked
      t.references :verse

      t.timestamps
    end
  end
end
