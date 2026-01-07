class AddConversationTypeToConversations < ActiveRecord::Migration[7.2]
  def change
    add_column :conversations, :conversation_type, :integer, default: 0
    add_index :conversations, :conversation_type
  end
end
