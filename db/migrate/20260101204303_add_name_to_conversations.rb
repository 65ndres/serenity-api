class AddNameToConversations < ActiveRecord::Migration[7.2]
  def change
    add_column :conversations, :name, :string
  end
end
