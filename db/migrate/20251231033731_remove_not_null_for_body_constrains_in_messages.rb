class RemoveNotNullForBodyConstrainsInMessages < ActiveRecord::Migration[7.2]
  def change
    change_column_null :messages, :body, true
    remove_column :messages, :body
  end
end
