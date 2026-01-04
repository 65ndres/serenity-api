class CreateAdminConversations < ActiveRecord::Migration[7.2]
  def change
    create_table :admin_conversations do |t|
      t.references :user, null: false, foreign_key: true
      t.text :body, null: false
      t.boolean :read, default: false, null: false

      t.timestamps
    end

    # add_index :admin_conversations, :user_id
  end
end

