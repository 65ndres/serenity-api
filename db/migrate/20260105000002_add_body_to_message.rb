class AddBodyToMessage < ActiveRecord::Migration[7.2]
  def change
    add_column :messages, :body, :text
  end
end
