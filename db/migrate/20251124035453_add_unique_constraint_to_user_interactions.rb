class AddUniqueConstraintToUserInteractions < ActiveRecord::Migration[7.2]
  def change
    # Add foreign key for user_id if it doesn't exist
    add_foreign_key :user_interactions, :users, column: :user_id unless foreign_key_exists?(:user_interactions, :users)
    
    # Add unique index to prevent duplicate likes
    add_index :user_interactions, [:user_id, :verse_id], unique: true, name: 'index_user_interactions_on_user_and_verse'
  end
end
